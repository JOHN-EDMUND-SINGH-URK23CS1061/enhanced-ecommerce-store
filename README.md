# eCommerce Microservices Project

A complete DevOps-ready eCommerce application built with microservices architecture, Docker containerization, and GitHub Actions CI/CD pipeline.

## 🏗️ Architecture

### System Overview

```
┌─────────────┐    HTTP     ┌──────────────────┐    HTTP     ┌──────────────────┐
│   Frontend  │ ◄─────────► │  Product Service │ ◄─────────► │  Order Service   │
│   (Nginx)   │             │   (Node.js)      │             │   (Node.js)      │
│   Port 3000 │             │    Port 3001     │             │    Port 3002     │
└─────────────┘             └──────────────────┘             └──────────────────┘
```

### Microservices

1. **Frontend Service** (Port 3000)
   - Static HTML/CSS/JavaScript website
   - Nginx web server
   - Product catalog display
   - Order placement interface

2. **Product Service** (Port 3001)
   - Product catalog management
   - RESTful API endpoints
   - In-memory data storage

3. **Order Service** (Port 3002)
   - Order processing
   - Product validation via Product Service
   - Order history management

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Git (for cloning the repository)

### Running the Application

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd ecommerce-microservices
   ```

2. **Start all services:**
   ```bash
   docker compose up --build
   ```

3. **Access the application:**
   - Frontend: http://localhost:3000
   - Product Service API: http://localhost:3001
   - Order Service API: http://localhost:3002

### Stopping the Application

```bash
docker compose down
```

## 📡 API Endpoints

### Product Service (Port 3001)

#### GET /products
Returns all products in the catalog.

**Response:**
```json
[
  {
    "id": 1,
    "name": "Laptop",
    "price": 999.99,
    "description": "High-performance laptop with 16GB RAM and 512GB SSD",
    "stock": 10
  }
]
```

#### GET /products/:id
Returns a specific product by ID.

**Response:**
```json
{
  "id": 1,
  "name": "Laptop",
  "price": 999.99,
  "description": "High-performance laptop with 16GB RAM and 512GB SSD",
  "stock": 10
}
```

#### POST /products
Adds a new product to the catalog.

**Request Body:**
```json
{
  "name": "New Product",
  "price": 299.99,
  "description": "Product description",
  "stock": 50
}
```

#### GET /health
Health check endpoint.

### Order Service (Port 3002)

#### POST /orders
Creates a new order with product validation.

**Request Body:**
```json
{
  "productId": 1,
  "quantity": 2,
  "customerName": "John Doe",
  "customerEmail": "john@example.com"
}
```

**Response:**
```json
{
  "id": 1,
  "productId": 1,
  "productName": "Laptop",
  "quantity": 2,
  "unitPrice": 999.99,
  "totalPrice": 1999.98,
  "customerName": "John Doe",
  "customerEmail": "john@example.com",
  "status": "pending",
  "createdAt": "2024-01-01T12:00:00.000Z"
}
```

#### GET /orders
Returns all orders.

#### GET /orders/:id
Returns a specific order by ID.

#### GET /health
Health check endpoint.

## 🐳 Docker Configuration

### Services

Each service runs in its own Docker container:

- **frontend**: Nginx Alpine serving static HTML
- **product-service**: Node.js Alpine with Express
- **order-service**: Node.js Alpine with Express

### Docker Compose Features

- **Health Checks**: Each service has health check endpoints
- **Service Dependencies**: Order service depends on product service
- **Network Isolation**: Services communicate via internal Docker network
- **Port Mapping**: Services exposed on different host ports

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

The project includes a comprehensive CI/CD pipeline in `.github/workflows/ci-cd.yml`:

#### CI Stage
- **Code Checkout**: Retrieves source code
- **Node.js Setup**: Configures Node.js 18 environment
- **Dependency Installation**: Installs npm packages for all services
- **Package Validation**: Verifies package.json files

#### Docker Stage
- **Image Building**: Builds Docker images for all services
- **Image Testing**: Validates that images start correctly
- **Health Check Testing**: Ensures services respond to health checks

#### Docker Compose Stage
- **Full Stack Testing**: Builds and runs complete application
- **Integration Testing**: Tests service communication
- **API Endpoint Testing**: Validates all API endpoints
- **Cleanup**: Removes containers and images after testing

### Pipeline Triggers

- **Push**: Triggers on push to `main` and `develop` branches
- **Pull Request**: Triggers on PR to `main` branch

## 📁 Project Structure

```
ecommerce-microservices/
├── frontend/
│   ├── index.html          # Main frontend application
│   └── Dockerfile          # Frontend Docker configuration
├── product-service/
│   ├── server.js           # Product service API
│   ├── package.json        # Node.js dependencies
│   └── Dockerfile          # Product service Docker configuration
├── order-service/
│   ├── server.js           # Order service API
│   ├── package.json        # Node.js dependencies
│   └── Dockerfile          # Order service Docker configuration
├── .github/
│   └── workflows/
│       └── ci-cd.yml       # GitHub Actions pipeline
├── docker-compose.yml      # Docker Compose configuration
└── README.md              # This file
```

## 🛠️ Development

### Local Development

To run services individually for development:

1. **Product Service:**
   ```bash
   cd product-service
   npm install
   npm run dev
   ```

2. **Order Service:**
   ```bash
   cd order-service
   npm install
   npm run dev
   ```

3. **Frontend:**
   ```bash
   cd frontend
   python -m http.server 3000  # Or use any static server
   ```

### Adding New Features

1. **Backend Services:**
   - Add new endpoints in respective `server.js` files
   - Update Docker images if new dependencies are added
   - Test with Docker Compose

2. **Frontend:**
   - Modify `index.html` for UI changes
   - Update JavaScript for new functionality
   - Ensure API calls match backend endpoints

## 🔧 Configuration

### Environment Variables

- **PRODUCT_SERVICE_URL**: URL of the product service (default: http://product-service:3001)
- **NODE_ENV**: Environment setting (development/production)

### Port Configuration

- Frontend: 3000
- Product Service: 3001
- Order Service: 3002

## 🐛 Troubleshooting

### Common Issues

1. **Port Conflicts:**
   - Ensure ports 3000, 3001, and 3002 are available
   - Check for other services using these ports

2. **Docker Issues:**
   - Run `docker system prune` to clean up unused containers
   - Ensure Docker daemon is running

3. **Service Communication:**
   - Check Docker network configuration
   - Verify service names in docker-compose.yml

### Health Checks

All services expose `/health` endpoints:
- Frontend: http://localhost:3000 (serves HTML)
- Product Service: http://localhost:3001/health
- Order Service: http://localhost:3002/health

## 📈 Monitoring and Logging

### Service Logs

View logs for individual services:
```bash
docker compose logs product-service
docker compose logs order-service
docker compose logs frontend
```

### Health Monitoring

Each service includes health check endpoints that are monitored by Docker Compose.

## 🔒 Security Considerations

- No authentication implemented (as per requirements)
- Services communicate within isolated Docker network
- CORS enabled for frontend-backend communication
- Input validation on API endpoints

## 🚀 Production Deployment

For production deployment:

1. **Environment Variables:**
   - Set appropriate NODE_ENV=production
   - Configure external service URLs

2. **Resource Limits:**
   - Add memory and CPU limits in docker-compose.yml
   - Configure proper logging and monitoring

3. **Database:**
   - Replace in-memory storage with persistent database
   - Add database migration scripts

4. **Load Balancing:**
   - Configure reverse proxy for multiple instances
   - Implement service discovery

## 📝 License

MIT License - feel free to use this project for learning and development purposes.
