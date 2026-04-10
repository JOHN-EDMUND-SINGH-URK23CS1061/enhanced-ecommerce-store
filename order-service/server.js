const express = require('express');
const cors = require('cors');
const axios = require('axios');
const app = express();
const PORT = process.env.PORT || 3002;

app.use(cors());
app.use(express.json());

const PRODUCT_SERVICE_URL = process.env.PRODUCT_SERVICE_URL || 'http://product-service:3001';

let orders = [];
let nextOrderId = 1;

// GET / - Root endpoint with API info
app.get('/', (req, res) => {
  res.json({
    service: 'Order Service',
    version: '1.0.0',
    endpoints: {
      'POST /orders': 'Create new order',
      'GET /orders': 'Get all orders',
      'GET /orders/:id': 'Get specific order by ID',
      'GET /health': 'Health check endpoint'
    },
    examples: {
      createOrder: {
        method: 'POST',
        url: `${req.protocol}://${req.get('host')}/orders`,
        body: {
          productId: 1,
          quantity: 2,
          customerName: 'John Doe',
          customerEmail: 'john@example.com'
        }
      },
      orders: `${req.protocol}://${req.get('host')}/orders`,
      health: `${req.protocol}://${req.get('host')}/health`
    }
  });
});

// Helper function to validate product exists
async function validateProduct(productId) {
  try {
    const response = await axios.get(`${PRODUCT_SERVICE_URL}/products/${productId}`);
    return response.data;
  } catch (error) {
    if (error.response && error.response.status === 404) {
      return null;
    }
    throw error;
  }
}

// POST /orders - Create new order
app.post('/orders', async (req, res) => {
  const { productId, quantity, customerName, customerEmail } = req.body;
  
  if (!productId || !quantity || !customerName || !customerEmail) {
    return res.status(400).json({ 
      error: 'Missing required fields: productId, quantity, customerName, customerEmail' 
    });
  }
  
  if (quantity <= 0) {
    return res.status(400).json({ 
      error: 'Quantity must be greater than 0' 
    });
  }
  
  try {
    // Validate product exists
    const product = await validateProduct(productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }
    
    // Check if enough stock is available
    if (product.stock < quantity) {
      return res.status(400).json({ 
        error: 'Insufficient stock. Available: ' + product.stock 
      });
    }
    
    const newOrder = {
      id: nextOrderId++,
      productId,
      productName: product.name,
      quantity,
      unitPrice: product.price,
      totalPrice: product.price * quantity,
      customerName,
      customerEmail,
      status: 'pending',
      createdAt: new Date().toISOString()
    };
    
    orders.push(newOrder);
    res.status(201).json(newOrder);
    
  } catch (error) {
    console.error('Error creating order:', error.message);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /orders - List all orders
app.get('/orders', (req, res) => {
  res.json(orders);
});

// GET /orders/:id - Get specific order
app.get('/orders/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const order = orders.find(o => o.id === id);
  
  if (!order) {
    return res.status(404).json({ error: 'Order not found' });
  }
  
  res.json(order);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', service: 'order-service', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`Order service running on port ${PORT}`);
  console.log(`Product service URL: ${PRODUCT_SERVICE_URL}`);
});
