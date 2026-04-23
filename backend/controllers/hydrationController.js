const HydrationLog = require('../models/HydrationLog');

// @desc  Add a hydration entry
// @route POST /api/hydration
const addHydrationEntry = async (req, res) => {
  try {
    const { userId = 'default_user', amount, note } = req.body;

    if (!amount || amount <= 0) {
      return res.status(400).json({ success: false, message: 'Amount must be positive' });
    }

    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD

    const log = await HydrationLog.create({
      userId,
      amount,
      note: note || '',
      date: today,
    });

    res.status(201).json({ success: true, data: log });
  } catch (error) {
    console.error('addHydrationEntry error:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// @desc  Get today's hydration logs
// @route GET /api/hydration/today
const getTodayLogs = async (req, res) => {
  try {
    const userId = req.query.userId || 'default_user';
    const today = new Date().toISOString().split('T')[0];

    const logs = await HydrationLog.find({ userId, date: today }).sort({ timestamp: 1 });

    const totalAmount = logs.reduce((sum, log) => sum + log.amount, 0);

    res.json({
      success: true,
      data: {
        logs,
        totalAmount,
        date: today,
        count: logs.length,
      },
    });
  } catch (error) {
    console.error('getTodayLogs error:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// @desc  Get weekly hydration analytics
// @route GET /api/hydration/weekly
const getWeeklyAnalytics = async (req, res) => {
  try {
    const userId = req.query.userId || 'default_user';

    // Last 7 days
    const dates = [];
    for (let i = 6; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      dates.push(d.toISOString().split('T')[0]);
    }

    const logs = await HydrationLog.find({
      userId,
      date: { $in: dates },
    });

    // Group by date
    const analytics = dates.map((date) => {
      const dayLogs = logs.filter((l) => l.date === date);
      const total = dayLogs.reduce((sum, l) => sum + l.amount, 0);
      return { date, total, count: dayLogs.length };
    });

    const totalWeekly = analytics.reduce((sum, d) => sum + d.total, 0);
    const avgDaily = Math.round(totalWeekly / 7);

    res.json({
      success: true,
      data: {
        analytics,
        totalWeekly,
        avgDaily,
        period: `${dates[0]} to ${dates[6]}`,
      },
    });
  } catch (error) {
    console.error('getWeeklyAnalytics error:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

// @desc  Delete a hydration log entry
// @route DELETE /api/hydration/:id
const deleteEntry = async (req, res) => {
  try {
    const log = await HydrationLog.findByIdAndDelete(req.params.id);
    if (!log) return res.status(404).json({ success: false, message: 'Log not found' });
    res.json({ success: true, message: 'Deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

module.exports = { addHydrationEntry, getTodayLogs, getWeeklyAnalytics, deleteEntry };