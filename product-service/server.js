const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

let products = [
  {
    id: 1,
    name: 'Laptop',
    price: 999.99,
    description: 'High-performance laptop with 16GB RAM and 512GB SSD',
    stock: 10
  },
  {
    id: 2,
    name: 'Smartphone',
    price: 699.99,
    description: 'Latest smartphone with 5G connectivity and dual camera',
    stock: 25
  },
  {
    id: 3,
    name: 'Headphones',
    price: 149.99,
    description: 'Wireless noise-cancelling headphones with 30-hour battery',
    stock: 15
  }
];

let nextId = 4;

// GET / - Root endpoint with API info
app.get('/', (req, res) => {
  res.json({
    service: 'Product Service',
    version: '1.0.0',
    endpoints: {
      'GET /products': 'Get all products',
      'GET /products/:id': 'Get specific product by ID',
      'POST /products': 'Create new product',
      'GET /health': 'Health check endpoint'
    },
    examples: {
      products: `${req.protocol}://${req.get('host')}/products`,
      health: `${req.protocol}://${req.get('host')}/health`
    }
  });
});

// GET /products - Return all products
app.get('/products', (req, res) => {
  res.json(products);
});

// GET /products/:id - Return specific product
app.get('/products/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const product = products.find(p => p.id === id);
  
  if (!product) {
    return res.status(404).json({ error: 'Product not found' });
  }
  
  res.json(product);
});

// POST /products - Add new product
app.post('/products', (req, res) => {
  const { name, price, description, stock } = req.body;
  
  if (!name || !price || !description || stock === undefined) {
    return res.status(400).json({ 
      error: 'Missing required fields: name, price, description, stock' 
    });
  }
  
  const newProduct = {
    id: nextId++,
    name,
    price: parseFloat(price),
    description,
    stock: parseInt(stock)
  };
  
  products.push(newProduct);
  res.status(201).json(newProduct);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', service: 'product-service', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`Product service running on port ${PORT}`);
});
