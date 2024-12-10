const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const cors = require('cors'); // CORS package for handling cross-origin requests

const app = express();
const target = 'https://api.murf.ai';  

// Enable CORS for all origins (only for development)
app.use(cors());

// Set up proxy for any requests that start with /api
app.use('/api', createProxyMiddleware({
  target: target,
  changeOrigin: true,
  pathRewrite: {
    '^/api': '', // Remove '/api' from the start of the path before forwarding
  },
  onProxyReq: (proxyReq, req, res) => {
    // Add CORS headers to the proxy request
    proxyReq.setHeader('Access-Control-Allow-Origin', '*');
    proxyReq.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    proxyReq.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  },
}));

// Start the server on port 3000
app.listen(3000, () => {
  console.log('Proxy server running on http://localhost:3000');
});