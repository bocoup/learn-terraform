require('dotenv').config();

const fs = require('fs');
const http = require('http');

const Busboy = require('busboy');
const AWS = require('aws-sdk');
const S3 = new AWS.S3({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  region: process.env.AWS_DEFAULT_REGION
});

function save(request, done) {
  return new Busboy({
    headers: request.headers
  }).on('file', function(fieldName, file, fileName, encoding, mimetype) {
    S3.upload({
      Bucket: process.env.AWS_S3_BUCKET,
      Body: file,
      ACL: 'public-read',
      ContentEncoding: encoding,
      ContentType: mimetype,
      Key: fileName
    }, function (err, data) {
      if (err) {
        return done(err);
      }
      done(null, data);
    });
  });
}

function handler (request, response) {
  if (request.method === 'POST') {
    return request.pipe(save(request, function (err, data) {
      if (err) {
        throw err;
      }
      response.writeHead(303, { Connection: 'close', Location: data.Location });
      response.end();
    }));
  }
  response.writeHead(200, { 'Content-Type': 'text/html' });
  response.end([
    '<!doctype html>',
    '<html>',
    '  <head>',
    '    <title>S3 Uploader</title>',
    '  </head>',
    '  <body>',
    '    <h1>S3 Uploader</h1>',
    '    <form enctype="multipart/form-data" method="post">',
    '      <input type="file" name="file" size="40"><br>',
    '      <input type="submit" value="send">',
    '    </form>',
    '  </body>',
    '</html>'
  ].join('\n'));
};

http.createServer(handler).listen(process.env.PORT, () => {
  console.log('Server listening on port '+process.env.PORT+'...');
});
