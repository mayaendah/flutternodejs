import express from "express";
import cors from "cors";
import prodRoute from "./routes/prodRoute.js";
import fileUpload from "express-fileupload";

 
const app = express();
app.use(cors());
app.use(express.json());
app.use(fileUpload());
app.use(express.static("public"));
app.use(prodRoute);

 
app.listen(5000, ()=> console.log('Server up and running...'));