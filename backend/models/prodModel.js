import {Sequelize} from "sequelize";
import db from "../config/Database.js";
 
const {DataTypes} = Sequelize;
 
const product = db.define('product',{
    pname: DataTypes.STRING,
    pprice: DataTypes.STRING,
    pdesc: DataTypes.STRING,
    pimg:DataTypes.STRING
},{
    freezeTableName:true
});
 
export default product;
 
(async()=>{
    await db.sync();
})();