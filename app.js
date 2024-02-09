const express = require('express');
const bodyParser = require('body-parser');

const {
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
} = require('./database.js'); // Use require instead of import
const app = express();

//increased size for string images
app.use(express.json({ limit: '100mb' }));
app.use(bodyParser.urlencoded({ limit: '100mb', extended: true }));
//functions of properties

//1)getting all properties function
const getallproperties = async (req, res) => {
  try {
    const properties = await getAllProperties();

    if (properties == null) l = 0;
    else l = properties.length;
    res.status(200).json({
      status: 'sucess',
      length: l,
      data: {
        properties,
      },
    });
  } catch (error) {
    res.status(404).json({
      status: 'fail',
      message: error,
    });
  }
};

//Done
//2)getting properties with username

const getProperties = async (req, res) => {
  const username = req.params.username;
  try {
    const property = await getproperty(username);
    if (property.length != 0) {
      res.status(200).json({
        status: 'sucess',
        data: {
          properties: property,
        },
      });
    } else {
      res.status(404).json({
        status: 'fail',
        message: 'username not found!',
      });
    }
  } catch (error) {
    res.status(500).json({
      status: 'fail',
      message: error,
    });
  }
};

const postProperty = async (req, res) => {
  const newProperty = req.body;
  console.log(newProperty);
  try {
    const result = await addNewProperty(newProperty);

    if (result != 'done') {
      res.status(400).send({ message: result.details });
    } else res.status(200).send(result);
  } catch (error) {
    res.status(500).send({ details: error.message });
  }
};

//user function
const getUser = async (req, res) => {
  const username = req.params.username;
  try {
    const User = await getuser(username);
    if (User.length != 0) {
      res.status(200).json({
        status: 'sucess',
        data: {
          user: User,
        },
      });
    } else {
      res.status(404).json({
        status: 'fail',
        message: 'user not found!',
      });
    }
  } catch (error) {
    res.status(500).json({
      status: 'fail',
      message: error,
    });
  }
};
//properties route
app.get('/api/v1/properties', getallproperties);
app.get('/api/v1/properties/:username', getProperties);
app.post('/api/v1/properties', postProperty);
//User routes
app.get('/api/v1/user/:username', getUser);

app.post('/api/v1/user', async (req, res) => {
  const newUser = req.body;
  try {
    const result = await addnewuser(newUser);
    //console.log(newUser);
    if (result != 'done') {
      res.status(400).send({ message: result.details });
    } else res.status(200).send(result);
  } catch (error) {
    res.status(500).send({ details: error.message });
  }
});
app.get('/api/v1/properties/myproperties/:username', async (req, res) => {
  try {
    const username = req.params.username;
    console.log(username);
    const property = await getMyProperty(username);
    if (property.length != 0) {
      res.status(200).json({
        status: 'sucess',
        data: {
          properties: property,
        },
      });
    } else {
      res.status(404).json({
        status: 'fail',
        message: 'Properties not found',
      });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({
      status: 'fail',
      message: error,
    });
  }
});
app.put('/api/v1/user/:username', async (req, res) => {
  const username = req.params.username;
  try {
    const result = await Updateuser(username, req.body);

    if (result === 'Done') {
      res.status(200).json({
        status: 'sucess',
        data: {
          message: 'Information Updated',
        },
      });
    } else {
      res.status(404).json({
        status: 'fail',
        message: 'user not found!',
      });
    }
  } catch (error) {
    res.status(500).json({
      status: 'fail',
      message: error,
    });
  }
});

app.delete('/api/v1/properties/deleteProperty/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const result = await deleteProperty(id);
    if (result === 'done') {
      res.status(202).json({
        status: 'sucess',
        data: {
          message: 'deleted',
        },
      });
    } else {
      res.status(404).json({
        status: 'fail',
        message: 'Property id not found',
      });
    }
  } catch (error) {
    res.status(500).json({
      status: 'fail',
      message: error,
    });
  }
});

app.put('/api/v1/properties/:id', async (req, res) => {
  try {
    const result = await updateProperty(req.body);

    if (result === 'Done') {
      res.status(200).json({
        status: 'sucess',
        data: {
          message: 'Information Updated',
        },
      });
    } else {
      res.status(404).json({
        status: 'fail',
        message: 'Property not found!',
      });
    }
  } catch (error) {
    res.status(500).json({
      status: 'fail',
      message: error,
    });
  }
});
app.get('/api/v1/properties/filters/:values', async (req, res) => {
  try {
    console.log('asas');
    console.log(req.params.values);
    const property = await applyPropertyfilter(req.params.values);
    if (property.length != 0) {
      res.status(200).json({
        status: 'sucess',
        data: {
          properties: property,
        },
      });
    } else {
      res.status(404).json({
        status: 'fail',
        message: 'Properties not found',
      });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({
      status: 'fail',
      message: error,
    });
  }
});
module.exports = app;
