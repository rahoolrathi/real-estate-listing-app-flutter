const mysql = require('mysql2/promise');
require('dotenv').config();

//Getting  Connection from sqlworkbench
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'FAST0342',
  database: 'realestatelisting',
});

//Properties functions
async function NewIdGenerator(tablename, columnname) {
  try {
    const result = await pool.query(
      `SELECT ${columnname} FROM ${tablename} ORDER BY ${columnname} DESC LIMIT 1`
    );

    if (result[0].length === 0) {
      // If no rows are returned, it means the table is empty, return 1 as the first ID
      return 1;
    }
    const lastId = result[0][0][columnname];
    if (isNaN(lastId)) {
      throw new Error(`Invalid ID found in the database ${tablename}.`);
    }
    const newId = parseInt(lastId, 10) + 1;
    return newId;
  } catch (error) {
    console.error(`Error in NewIdGenerator ${tablename}: ${error.message}`);
    throw error;
  }
}

async function alreadychecker(tablename, columnname, value, columnname2) {
  console.log(columnname);
  const existingType = await pool.query(
    `SELECT ${columnname} FROM ${tablename} WHERE ${columnname2} = ?`,
    [value]
  );

  if (existingType[0][0]) {
    if (existingType[0][0][columnname]) {
      console.log(`id exist ${tablename}` + existingType[0][0][columnname]);
      return existingType[0][0][columnname];
    }
  }

  const id = await NewIdGenerator(tablename, columnname);
  await pool.query(`INSERT INTO ${tablename}  VALUES (?, ?)`, [id, value]);
  return id;
}

async function addNewProperty(property) {
  console.log('---------------------------------------------------');
  console.log(property);
  let connection;
  try {
    connection = await pool.getConnection();
    await connection.beginTransaction();

    const {
      propertyType,
      user: { username },
      city,
      area,
      price,
      bedrooms,
      bathrooms,
      isInstallmentAvailable,
      finnace: { advanceAmount, installmentAmount, noOfInstallments },
      title,
      description,
      images,
    } = property;

    const imageUrls = await Promise.all(
      images.map(async (base64Image) => {
        const imageBuffer = Buffer.from(base64Image, 'base64');
        return imageBuffer;
      })
    );

    const typeId = await alreadychecker(
      'propertyType',
      'propertyTypeID',
      propertyType,
      'typename'
    );

    const cityId = await alreadychecker('cities', 'cityID', city, 'cityname');

    const propertyId = await NewIdGenerator('property', 'propertyID');
    const currentDate = await pool.query(
      "select DATE_FORMAT(CURDATE(), '%d-%m-%y')"
    );
    const date = currentDate[0][0]["DATE_FORMAT(CURDATE(), '%d-%m-%y')"];

    await pool.query('INSERT INTO property values(?,?,?,?,?,?,?,?,?,?,?,?)', [
      propertyId,
      cityId,
      typeId,
      username,
      title,
      description,
      parseInt(bedrooms),
      parseInt(bathrooms),
      parseFloat(area),
      parseFloat(price),
      Boolean(isInstallmentAvailable),
      date,
    ]);

    await Promise.all(
      imageUrls.map(async (imageUrl) => {
        await pool.query(
          'INSERT INTO propertyImages (propertyID, imageurl) VALUES (?, ?)',
          [propertyId, imageUrl]
        );
      })
    );

    console.log(noOfInstallments);
    if (Boolean(isInstallmentAvailable)) {
      await pool.query(
        'INSERT INTO finnace (propertyID,downpayment,installmentAmount,noOfInstallments)  VALUES (?, ?,?,?)',
        [
          propertyId,
          parseFloat(advanceAmount),
          parseFloat(installmentAmount),
          parseInt(noOfInstallments),
        ]
      );
    }

    await connection.commit();
  } catch (error) {
    console.error(`Error adding property: ${error.message}`);
    if (connection) {
      await connection.rollback();
    }
    throw new Error('Failed to add property.');
  } finally {
    if (connection) {
      connection.release();
    }
  }
  return 'done';
}

async function getAllProperties() {
  let connection;
  try {
    connection = await pool.getConnection();
    await connection.beginTransaction();

    const [propertyResults] = await connection.query(`
      SELECT 
        p.propertyID,
        p.title,
        p.descripation AS description,
        p.bedrooms,
        p.bathrooms,
        p.area,
        p.price,
        p.isInstallmentAvailable,
        p.dateposted,
        c.cityname AS city,
        pt.typename AS propertyType,
        u.username AS user,
        u.fullname AS fullName,
        u.phonenumber AS phoneNumber,
        u.userimage AS userImage,
        f.downpayment,
        f.installmentAmount,
        f.noOfInstallments,
        pi.imageurl
      FROM property p
      LEFT JOIN cities c ON p.cityID = c.cityID
      LEFT JOIN propertyType pt ON p.propertyTypeId = pt.propertyTypeID
      LEFT JOIN user u ON p.username = u.username
      LEFT JOIN finnace f ON p.propertyID = f.propertyID
      LEFT JOIN propertyImages pi ON p.propertyID = pi.propertyID
    `);

    if (!propertyResults || propertyResults.length === 0) {
      // No properties found, return an empty array
      return [];
    }

    const organizedResults = propertyResults.reduce((acc, property) => {
      const propertyID = property.propertyID;

      if (!acc[propertyID]) {
        acc[propertyID] = {
          propertyID,
          title: property.title,
          description: property.description,
          bedrooms: property.bedrooms,
          bathrooms: property.bathrooms,
          area: property.area,
          price: property.price,
          isInstallmentAvailable: property.isInstallmentAvailable,
          dateposted: property.dateposted,
          city: property.city,
          propertyType: property.propertyType,
          user: {
            username: property.user,
            fullname: property.fullName,
            phonenumber: property.phoneNumber,
            userimage: property.userImage,
          },
          finnace: {},
          images: [],
        };
      }

      if (property.downpayment !== null) {
        acc[propertyID].finnace = {
          downpayment: property.downpayment,
          installmentAmount: property.installmentAmount,
          noOfInstallments: property.noOfInstallments,
        };
      }

      if (property.imageurl !== null) {
        acc[propertyID].images.push(property.imageurl);
      }

      return acc;
    }, {});

    const finalResults = Object.values(organizedResults);

    await connection.commit();
    console.log(finalResults);
    return finalResults;
  } catch (error) {
    console.error(`Error fetching properties: ${error.message}`);
    if (connection) {
      await connection.rollback();
    }
    throw new Error('Failed to fetch properties.');
  } finally {
    if (connection) {
      connection.release();
    }
  }
}

async function getproperty(username) {
  const [result] = await pool.query('SELECT * FROM property where username=?', [
    username,
  ]);
  return result[0]; // Assuming result[0] contains the rows
}

async function getuser(username) {
  const result = await pool.query('SELECT * FROM user where username=?', [
    username,
  ]);

  return result[0];
}

async function addnewuser(user) {
  console.log(user);
  const { username, fullname, phonenumber, password, userimage } = user;
  console.log(username);
  try {
    const result = await pool.query(
      'INSERT INTO user  VALUES (?, ?, ?, ?, ?)',
      [username, fullname, BigInt(phonenumber), password, userimage]
    );
    //console.log('kkk' + result);
    return 'done';
  } catch (error) {
    if (error.message === "Check constraint 'user_chk_1' is violated.")
      error.message =
        'Invalid Number. Please enter a valid Pakistani phone number starting with 03.';
    else if (error.message === "Check constraint 'user_chk_2' is violated.")
      error.message = 'Invalid Password. atleast 6 char password';
    return { type: 'database', details: error.message };
  }
}

async function Updateuser(username, body) {
  try {
    console.log(body.fullname);
    const { fullname, phonenumber, password, userimage } = body;

    let imageBuffer = null;

    if (userimage) {
      imageBuffer = Buffer.from(userimage, 'base64');
    }

    const result = await pool.query(
      'UPDATE user SET fullname = ?, phonenumber = ?, password = ?, userimage = ? WHERE username = ?',
      [fullname, BigInt(phonenumber), password, imageBuffer, username]
    );

    // Note: It's `pool.commit()` instead of `pool.commit` to actually commit the transaction.
    // Assuming `pool` has a `commit` method. If not, replace it with the correct method.
    pool.commit;
  } catch (error) {
    throw new Error(error);
  }

  return 'Done';
}

async function getMyProperty(username) {
  let connection;
  try {
    connection = await pool.getConnection();
    await connection.beginTransaction();

    const propertyResults = (
      await connection.query(
        `
      SELECT 
        p.propertyID,
        p.title,
        p.descripation AS description,
        p.bedrooms,
        p.bathrooms,
        p.area,
        p.price,
        p.isInstallmentAvailable,
        p.dateposted,
        c.cityname AS city,
        pt.typename AS propertyType,
        u.username AS user,
        u.fullname AS fullName,
        u.phonenumber AS phoneNumber,
        u.userimage AS userImage,
        f.downpayment,
        f.installmentAmount,
        f.noOfInstallments,
        pi.imageurl
      FROM property p
      LEFT JOIN cities c ON p.cityID = c.cityID
      LEFT JOIN propertyType pt ON p.propertyTypeId = pt.propertyTypeID
      LEFT JOIN user u ON p.username = u.username
      LEFT JOIN finnace f ON p.propertyID = f.propertyID
      LEFT JOIN propertyImages pi ON p.propertyID = pi.propertyID
      WHERE u.username = ?
    `,
        [username]
      )
    )[0];

    if (!propertyResults || propertyResults.length === 0) {
      // No properties found, return an empty array
      return 'Done';
    }
    const organizedResults = propertyResults.reduce((acc, property) => {
      const propertyID = property.propertyID;

      if (!acc[propertyID]) {
        acc[propertyID] = {
          propertyID,
          title: property.title,
          description: property.description,
          bedrooms: property.bedrooms,
          bathrooms: property.bathrooms,
          area: property.area,
          price: property.price,
          isInstallmentAvailable: property.isInstallmentAvailable,
          dateposted: property.dateposted,
          city: property.city,
          propertyType: property.propertyType,
          user: {
            username: property.user,
            fullname: property.fullName,
            phonenumber: property.phoneNumber,
            userimage: property.userImage,
          },
          finnace: {},
          images: [],
        };
      }

      if (property.downpayment !== null) {
        acc[propertyID].finnace = {
          downpayment: property.downpayment,
          installmentAmount: property.installmentAmount,
          noOfInstallments: property.noOfInstallments,
        };
      }

      if (property.imageurl !== null) {
        acc[propertyID].images.push(property.imageurl);
      }

      return acc;
    }, {});

    const finalResults = Object.values(organizedResults);

    await connection.commit();
    console.log(finalResults);
    return finalResults;
  } catch (error) {
    console.error(`Error fetching properties: ${error.message}`);
    if (connection) {
      await connection.rollback();
    }
    throw new Error('Failed to fetch properties.');
  } finally {
    if (connection) {
      connection.release();
    }
  }
}

async function applyPropertyfilter(filters) {
  try {
    const jsonData = JSON.parse(filters);

    filters = jsonData;

    connection = await pool.getConnection();
    await connection.beginTransaction();

    // Build the dynamic part of the WHERE clause based on filters
    let whereClause = 'WHERE c.cityname = ?';
    const filterValues = [filters.city];

    whereClause += ' AND p.bedrooms = ?';
    filterValues.push(filters.bedrooms);
    whereClause += ' AND p.bathrooms = ?';
    filterValues.push(filters.bathrooms);

    if (filters.installment) {
      whereClause += ' AND p.isInstallmentAvailable = ?';
      filterValues.push(filters.installment);
    }
    whereClause += ' AND p.price >= ? AND p.price <= ?';
    filterValues.push(filters.priceRange.min, filters.priceRange.max);

    console.log(filterValues);
    const propertyResults = (
      await connection.query(
        `
      SELECT 
        p.propertyID,
        p.title,
        p.descripation AS description,
        p.bedrooms,
        p.bathrooms,
        p.area,
        p.price,
        p.isInstallmentAvailable,
        p.dateposted,
        c.cityname AS city,
        pt.typename AS propertyType,
        u.username AS user,
        u.fullname AS fullName,
        u.phonenumber AS phoneNumber,
        u.userimage AS userImage,
        f.downpayment,
        f.installmentAmount,
        f.noOfInstallments,
        pi.imageurl
      FROM property p
      LEFT JOIN cities c ON p.cityID = c.cityID
      LEFT JOIN propertyType pt ON p.propertyTypeId = pt.propertyTypeID
      LEFT JOIN user u ON p.username = u.username
      LEFT JOIN finnace f ON p.propertyID = f.propertyID
      LEFT JOIN propertyImages pi ON p.propertyID = pi.propertyID
      ${whereClause}
    `,
        filterValues
      )
    )[0];

    console.log(propertyResults);
    if (!propertyResults || propertyResults.length === 0) {
      // No properties found, return an empty array
      return 'Done';
    }
    const organizedResults = propertyResults.reduce((acc, property) => {
      const propertyID = property.propertyID;

      if (!acc[propertyID]) {
        acc[propertyID] = {
          propertyID,
          title: property.title,
          description: property.description,
          bedrooms: property.bedrooms,
          bathrooms: property.bathrooms,
          area: property.area,
          price: property.price,
          isInstallmentAvailable: property.isInstallmentAvailable,
          dateposted: property.dateposted,
          city: property.city,
          propertyType: property.propertyType,
          user: {
            username: property.user,
            fullname: property.fullName,
            phonenumber: property.phoneNumber,
            userimage: property.userImage,
          },
          finnace: {},
          images: [],
        };
      }

      if (property.downpayment !== null) {
        acc[propertyID].finnace = {
          downpayment: property.downpayment,
          installmentAmount: property.installmentAmount,
          noOfInstallments: property.noOfInstallments,
        };
      }

      if (property.imageurl !== null) {
        acc[propertyID].images.push(property.imageurl);
      }

      return acc;
    }, {});

    const finalResults = Object.values(organizedResults);

    await connection.commit();
    console.log(finalResults);
    return finalResults;
  } catch (error) {
    console.error(`Error fetching properties: ${error.message}`);
    if (connection) {
      await connection.rollback();
    }
    throw new Error('Failed to fetch properties.');
  } finally {
    if (connection) {
      connection.release();
    }
  }
}

async function deleteProperty(id) {
  let connection;
  try {
    connection = await pool.getConnection();
    await connection.beginTransaction();
    const [checkResult] = await connection.query(
      'SELECT * FROM property WHERE propertyID = ?',
      [id]
    );
    console.log(checkResult.length);
    if (checkResult.length === 0) {
      await connection.rollback();
      return 'fail';
    }
    const [result] = await connection.query(
      'DELETE FROM property WHERE propertyID = ?',
      [id]
    );

    await connection.commit();

    console.log(result);
    return 'done';
  } catch (error) {
    if (connection) {
      await connection.rollback();
    }
    throw new Error(`Error deleting property: ${error.message}`);
  } finally {
    if (connection) {
      connection.release();
    }
  }
}

async function updateProperty(propertyID, updates) {
  let connection;
  try {
    connection = await pool.getConnection();
    await connection.beginTransaction();

    // Update property details
    await connection.query(
      `
      UPDATE property
      SET
        cityID = (SELECT cityID FROM cities WHERE cityname = ?),
        propertyTypeId = (SELECT propertyTypeID FROM propertyType WHERE typename = ?),
        bedrooms = ?,
        bathrooms = ?,
        descripation = ?,
        title = ?,
        area = ?,
        price = ?,
        isInstallmentAvailable = ?,
        dateposted = ?
      WHERE propertyID = ?
    `,
      [
        updates.city,
        updates.propertyType,
        updates.bedrooms,
        updates.bathrooms,
        updates.description,
        updates.title,
        updates.area,
        updates.price,
        updates.isInstallmentAvailable,
        new Date(), // Assuming you want to update the dateposted to the current date
        propertyID,
      ]
    );

    // Update finance details if available
    if (updates.finance) {
      await connection.query(
        `
        UPDATE finnace
        SET
          downpayment = ?,
          installmentAmount = ?,
          noOfInstallments = ?
        WHERE propertyID = ?
      `,
        [
          updates.finance.downpayment,
          updates.finance.installmentAmount,
          updates.finance.noOfInstallments,
          propertyID,
        ]
      );
    }

    // Delete existing images for the property
    await connection.query('DELETE FROM propertyImages WHERE propertyID = ?', [
      propertyID,
    ]);

    const imageUrls = await Promise.all(
      updates.images.map(async (base64Image) => {
        // Convert each base64-encoded image to a Buffer
        const imageBuffer = Buffer.from(base64Image, 'base64');
        return imageBuffer;
      })
    );

    // Insert new images
    if (imageUrls.length > 0) {
      const imageValues = imageUrls.map((imageBuffer) => [
        propertyID,
        imageBuffer,
      ]);
      await connection.query(
        'INSERT INTO propertyImages (propertyID, imageurl) VALUES ?',
        [imageValues]
      );
    }
    await connection.commit();

    return 'Property updated successfully';
  } catch (error) {
    if (connection) {
      await connection.rollback();
    }
    console.error(`Error updating property: ${error.message}`);
    throw new Error('Failed to update property.');
  } finally {
    if (connection) {
      connection.release();
    }
  }
}

module.exports = {
  getAllProperties,
  getproperty,
  getuser,
  addnewuser,
  Updateuser,
  addNewProperty,
  getMyProperty,
  deleteProperty,
  applyPropertyfilter,
  updateProperty,
};
