import express from "express";
import {
    getProd, 
    getProdById,
    createProd,
    updateProd,
    deleteProd
} from "../controllers/prodController.js";
 
const router = express.Router();
 
router.get('/products', getProd);
router.get('/products/:id', getProdById);
router.post('/products', createProd);
router.patch('/products/:id', updateProd);
router.delete('/products/:id', deleteProd);
 
export default router;