const mongoose = require('mongoose');

const HydrationLogSchema = new mongoose.Schema({
  userId: {
    type: String,
    default: 'default_user', // Extend with auth later
  },
  amount: {
    type: Number, // in ml
    required: true,
    min: 1,
  },
  note: {
    type: String,
    default: '',
  },
  date: {
    type: String, // YYYY-MM-DD format
    required: true,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

// Index for fast date-based queries
HydrationLogSchema.index({ userId: 1, date: 1 });

module.exports = mongoose.model('HydrationLog', HydrationLogSchema);