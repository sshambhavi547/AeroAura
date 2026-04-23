const express = require('express');
const router = express.Router();
const {
  addHydrationEntry,
  getTodayLogs,
  getWeeklyAnalytics,
  deleteEntry,
} = require('../controllers/hydrationController');

router.post('/', addHydrationEntry);
router.get('/today', getTodayLogs);
router.get('/weekly', getWeeklyAnalytics);
router.delete('/:id', deleteEntry);

module.exports = router;