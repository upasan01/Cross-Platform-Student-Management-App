const express = require('express');
const router = express.Router();
const Student = require('../models/student');

// Route: GET /api/students/search?query=rohit&category=name
router.get('/search', async (req, res) => {
  const { query, category } = req.query;

  if (!query || !category) {
    return res.status(400).json({ error: 'Query and category are required' });
  }

  try {
    const filter = {};
    filter[`studentDetails.${category}`] = { $regex: new RegExp(query, 'i') };

    const student = await Student.find(filter);
    console.log('Found Students:', student);

    if (!student) {
      return res.status(404).json({ error: 'Student not found' });
    }

    res.json(student);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
