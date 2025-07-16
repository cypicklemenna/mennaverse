<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Mennaverese</title>
  <link href="https://fonts.googleapis.com/css2?family=Rubik:wght@400;600&display=swap" rel="stylesheet" />
  <style>
    :root {
      --peige: #c9a882;
      --peige-light: #ddc5aa;
      --peige-dark: #b18e6d;
      --text-color: #2c2a25;
    }

    body {
      margin: 0;
      padding: 0;
      font-family: 'Rubik', sans-serif;
      background-color: var(--peige);
      color: var(--text-color);
    }

    .hero {
      height: 100vh;
      background: url('https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1752584759/q1xqpho1cf87esvhfxhv.jpg') no-repeat center center;
      background-size: cover;
      position: relative;
    }

    .quote {
      max-width: 850px;
      margin: 20px auto 40px;
      font-size: 1.3em;
      font-style: normal;
      font-weight: bold;
      color: var(--text-color);
      text-align: left;
      font-family: Georgia, serif;
      padding: 0;
      background: none;
      border: none;
      box-shadow: none;
    }

    .page {
      max-width: 850px;
      margin: 0 auto 80px;
      padding: 0 20px;
      background-color: var(--peige);
    }

    .add-post {
      background: var(--peige-light);
      padding: 20px;
      border: 2px solid var(--peige-dark);
      border-radius: 12px;
      margin-bottom: 40px;
      display: none;
    }

    h2 {
      color: var(--text-color);
      margin-top: 0;
    }

    textarea, input[type="text"] {
      width: 100%;
      padding: 12px;
      margin-bottom: 12px;
      background: #fef9f4;
      border: 1px solid var(--peige-dark);
      color: var(--text-color);
      border-radius: 8px;
      font-family: inherit;
    }

    button {
      background: var(--text-color);
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 6px;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.3s;
    }

    button:hover {
      background: #1a1815;
    }

    .post {
      background: var(--peige-light);
      border: 1px solid var(--peige-dark);
      padding: 20px;
      border-radius: 12px;
      margin-bottom: 30px;
    }

    .post h2 {
      color: var(--text-color);
      margin-bottom: 5px;
    }

    .date {
      font-size: 0.9em;
      color: #5c4b3b;
      margin-bottom: 10px;
    }

    .post img {
      max-width: 100%;
      border-radius: 8px;
      margin: 15px 0;
    }

    a {
      color: var(--text-color);
      text-decoration: none;
      font-size: 0.9em;
    }

    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

  <div class="hero"></div>

  <div class="page">

    <div class="quote">“Man ist nicht immer frei, aber man kann immer rebellieren.”</div>

    <div id="addPostSection" class="add-post">
      <h2>Add New Post</h2>
      <input type="text" id="post-title" placeholder="Post Title" />
      <textarea id="post-content" rows="5" placeholder="Write your post here..."></textarea>
      <input type="text" id="post-image" placeholder="Image URL (optional)" />
      <button onclick="addPost()">Publish Post</button>
    </div>

    <div id="posts-container"></div>
  </div>

  <script>
    const urlParams = new URLSearchParams(window.location.search);
    const isAdmin = urlParams.get('admin') === 'true';

    window.onload = function () {
      if (isAdmin) {
        document.getElementById('addPostSection').style.display = 'block';
      }
      loadPosts();
    };

    function savePosts(posts) {
      localStorage.setItem('mennaveresePosts', JSON.stringify(posts));
    }

    function loadPosts() {
      const posts = JSON.parse(localStorage.getItem('mennaveresePosts')) || [];
      const container = document.getElementById('posts-container');
      container.innerHTML = '';
      posts.forEach((post, index) => {
        container.appendChild(createPostElement(post.title, post.content, post.imageUrl, post.date, index));
      });
    }

    function createPostElement(title, content, imageUrl, date, index) {
      const postElement = document.createElement('div');
      postElement.className = 'post';

      const safeContent = content.replace(/\n/g, '<br>');
      const postDate = date || new Date().toLocaleDateString('en-GB');

      postElement.innerHTML = `
        <h2>${title}</h2>
        <div class="date">${postDate}</div>
        ${imageUrl ? `<img src="${imageUrl}" alt="Post image">` : ''}
        <p>${safeContent}</p>
        ${isAdmin ? `
          <p>
            <a href="#" class="edit-link">Edit</a> | 
            <a href="#" class="delete-link">Delete</a>
          </p>
        ` : ''}
      `;

      if (isAdmin) {
        postElement.querySelector('.delete-link').addEventListener('click', (e) => {
          e.preventDefault();
          const posts = JSON.parse(localStorage.getItem('mennaveresePosts')) || [];
          posts.splice(index, 1);
          savePosts(posts);
          loadPosts();
        });

        postElement.querySelector('.edit-link').addEventListener('click', function (e) {
          e.preventDefault();
          const h2 = postElement.querySelector('h2');
          const p = postElement.querySelector('p');

          if (this.textContent === 'Edit') {
            h2.contentEditable = true;
            p.contentEditable = true;
            h2.style.backgroundColor = '#f5eee5';
            p.style.backgroundColor = '#f5eee5';
            h2.focus();
            this.textContent = 'Save';
          } else {
            h2.contentEditable = false;
            p.contentEditable = false;
            h2.style.backgroundColor = '';
            p.style.backgroundColor = '';
            const posts = JSON.parse(localStorage.getItem('mennaveresePosts')) || [];
            posts[index].title = h2.textContent.trim();
            posts[index].content = p.innerHTML.replace(/<br>/g, '\n').trim();
            savePosts(posts);
            loadPosts();
          }
        });
      }

      return postElement;
    }

    function addPost() {
      const title = document.getElementById('post-title').value.trim();
      const content = document.getElementById('post-content').value.trim();
      const imageUrl = document.getElementById('post-image').value.trim();
      const date = new Date().toLocaleDateString('en-GB');

      if (!title || !content) {
        alert('Please add both title and content');
        return;
      }

      const posts = JSON.parse(localStorage.getItem('mennaveresePosts')) || [];

      posts.unshift({ title, content, imageUrl, date });
      savePosts(posts);
      loadPosts();

      document.getElementById('post-title').value = '';
      document.getElementById('post-content').value = '';
      document.getElementById('post-image').value = '';
    }
  </script>

</body>
</html>
