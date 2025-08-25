const { MongoMemoryServer } = require('mongodb-memory-server');

let mongod;

const startTestDb = async () => {
  try {
    mongod = await MongoMemoryServer.create({
      instance: {
        port: 27017,
        dbName: 'samwise-dev'
      }
    });
    
    const uri = mongod.getUri();
    console.log('In-memory MongoDB started:', uri);
    return uri;
  } catch (error) {
    console.error('Failed to start in-memory MongoDB:', error);
    throw error;
  }
};

const stopTestDb = async () => {
  if (mongod) {
    await mongod.stop();
    console.log('In-memory MongoDB stopped');
  }
};

module.exports = { startTestDb, stopTestDb };