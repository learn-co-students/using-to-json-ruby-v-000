Post.destroy_all
Author.destroy_all

author1 = Author.create(name: "Stephen King")
author2 = Author.create(name: "Ariana Huffington")
author3 = Author.create(name: "Horse Ebooks")

post1 = "This is a blog post by Stephen King. It will probably be a movie soon."
post2 = "I founded an empire but I can still blog on this lesson for funzies."
post3 = "Last night I dreamt we simply need to realize to be so competitive."

Post.create(title: "A Blog Post By Stephen King", description: post1, author: author1)
Post.create(title: "I'm doing Great", description: post2, author: author2)
Post.create(title: "Links Click Links", description: post3, author: author3)
