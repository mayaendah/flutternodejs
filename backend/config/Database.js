import {Sequelize} from "sequelize";
 
const db = new Sequelize('productapp','root','',{
    host: 'localhost',
    dialect: 'mysql'
});
 
export default db;