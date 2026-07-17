require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const connectDB = require('./config/db');
const hydrationRoutes = require('./routes/hydrationRoutes');

const app = express();
app.use(express.json());
// Connect to MongoDB
connectDB();

// Middleware
app.use(cors());
app.use(express.json());

// Health Check
app.get('/', (req, res) => {
  res.json({ status: 'AeroAura Backend is running 🌤️', version: '1.0.0' });
});

// Routes
app.use('/api/hydration', hydrationRoutes);

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error(err));


const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 AeroAura server running on http://localhost:${PORT}`);
});
