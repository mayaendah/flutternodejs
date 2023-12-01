import product from "../models/prodModel.js";
import path from "path";
import fs from "fs";
 
export const getProd = async(req, res) =>{
    try {
        const response = await product.findAll();
        res.status(200).json(response);
    } catch (error) {
        console.log(error.message);
    }
}
 
export const getProdById = async(req, res) =>{
    try {
        const response = await product.findOne({
            where:{
                id: req.params.id
            }
        });
        res.status(200).json(response);
    } catch (error) {
        console.log(error.message);
    }
}
 
// export const createProd = async(req, res) =>{
//     try {
//         await product.create(req.body);
//         res.status(201).json({msg: "Product Created"});
//     } catch (error) {
//         console.log(error.message);
//     }
// }

export const createProd = (req, res)=>{
    if(req.files === null) return res.status(400).json({msg: "No File Uploaded"});
    const pname = req.body.pname;
    const pprice = req.body.pprice;
    const pdesc = req.body.pdesc;
    
    const pimg = req.files.pimg;
    // console.log(pimg);

    
    const fileSize = pimg.data.length;
    const ext = path.extname(pimg.name);
    const fileName = pimg.md5 + ext;
    const allowedType = ['.png','.jpg','.jpeg'];

    if(!allowedType.includes(ext.toLowerCase())) return res.status(422).json({msg: "Invalid Images"});
    if(fileSize > 5000000) return res.status(422).json({msg: "Image must be less than 5 MB"});

    pimg.mv(`./public/images/${fileName}`, async(err)=>{
        if(err) return res.status(500).json({msg: err.message});
        try {
            await product.create({pname: pname,pprice:pprice,pdesc:pdesc, pimg: fileName});
            res.status(201).json({msg: "Product Created Successfuly"});
        } catch (error) {
            console.log(error.message);
        }
    })

}
 
// export const updateProd = async(req, res) =>{
//     try {
//         await product.update(req.body,{
//             where:{
//                 id: req.params.id
//             }
//         });
//         res.status(200).json({msg: "Product Updated"});
//     } catch (error) {
//         console.log(error.message);
//     }
// }

export const updateProd = async(req, res)=>{
    const Product = await product.findOne({
        where:{
            id : req.params.id
        }
    });
    if(!Product) return res.status(404).json({msg: "No Data Found"});
    console.log(Product);
    let fileName = "";
    if(req.files === null){
        fileName = Product.pimg;
    }else{
        const file = req.files.pimg; console.log(file);
        const fileSize = file.data.length; console.log(fileSize)
        const ext = path.extname(file.name);console.log("ext"+ext)
        fileName = file.md5 + ext;console.log("filename"+fileName)
        const allowedType = ['.png','.jpg','.jpeg'];

        if(!allowedType.includes(ext.toLowerCase())) return res.status(422).json({msg: "Invalid Images"});
        if(fileSize > 5000000) return res.status(422).json({msg: "Image must be less than 5 MB"});

        const filepath = `./public/images/${Product.pimg}`;
        fs.unlinkSync(filepath);

        file.mv(`./public/images/${fileName}`, (err)=>{
            if(err) return res.status(500).json({msg: err.message});
        });
    }
    const pname = req.body.pname;
    const pprice = req.body.pprice;
    const pdesc = req.body.pdesc;
    // const url = `${req.protocol}://${req.get("host")}/images/${fileName}`;
    
    try {
        await Product.update({pname: pname, pprice: pprice, pdesc: pdesc,pimg:fileName},{
            where:{
                id: req.params.id
            }
        });
        res.status(200).json({msg: "Product Updated Successfuly"});
    } catch (error) {
        console.log(error.message);
    }
}
 
export const deleteProd = async(req, res) =>{
    const Product = await product.findOne({
        where:{
            id : req.params.id
        }
    });
    if(!Product) return res.status(404).json({msg: "No Data Found"});

    try {
        const filepath = `./public/images/${Product.pimg}`;
        fs.unlinkSync(filepath);
        await product.destroy({
            where:{
                id : req.params.id
            }
        });
        res.status(200).json({msg: "Product Deleted Successfuly"});
    } catch (error) {
        console.log(error.message);
    }
}