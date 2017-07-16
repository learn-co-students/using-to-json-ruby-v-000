# Using to_json

## Objectives

1. Use the `to_json` method to render an object as JSON.
2. Explain how to render different formats from the same controller action.

## Lesson

Last time out we created a `PostSerializer` and used it to serialize a `Post` to JSON.

It worked great, but doing all that string concatenation and keeping track of the different quotes was kind of a nightmare. Imagine having to write serializers by hand for objects with more than four fields!

![nanny shocked](http://i.giphy.com/LJPfWhMCs9Rks.gif)

This is something people do every day in Rails, so there has to be a better way, right?

### to_json

Of course there is. Rails provides the `to_json` method which will take our object and, well, convert it to JSON. Let's see it in action. In our controller, let's swap our call to the `PostSerializer` for a `to_json`.

```ruby
# posts_controller.rb
# ...
  def post_data
    post = Post.find(params[:id])
    render json: post.to_json
  end
```

Okay, well, surely it can't be that simple. Let's load up our Rails server and browse to `/posts`. Click one of the "More" buttons, and, just like that, it updates the post body. We didn't have to change a thing. Think of it as a testament to how great a job we did writing our own serializer.

#### Including Associations

Now if we click on the first post and use our `Next...` link, that should mostly work too.

I say mostly, because it's not updating the author name. That's something we added in to our serializer, but by default, `to_json` only serializes the main object, not any associations. How can we change that?

You can tell `to_json` what associated objects to include, using the `include` option.

```ruby
# posts_controller.rb
# ...
  def post_data
    post = Post.find(params[:id])
    render json: post.to_json(include: :author)
  end
```

Now if we reload that post show page and click `Next`, the author should update as well.

#### Only Render The Data We Need

If we browse to `/posts/id/post_data`, we can see the raw JSON of our object. It should look something like this:

```javascript
{
  id: 1,
  title: "A Blog Post By Stephen King",
  description: "This is a blog post by Stephen King. It will probably be a movie soon.",
  created_at: "2016-02-22T00:29:21.022Z",
  updated_at: "2016-02-22T00:29:21.022Z",
  author_id: 1,
    author: {
      id: 1,
      name: "Stephen King",
      hometown: null,
      created_at: "2016-02-22T00:29:20.999Z",
      updated_at: "2016-02-22T00:29:20.999Z"
    }
}
```

**Note:** This would be a great time to install [JSONView](https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc?hl=en) if you haven't already!

It's great that `to_json` gives us all this, but we don't really need all of it.

A good API endpoint should return *only* the data that is needed, nothing more. So how do we get rid of that stuff?

It turns out `to_json` gives us ways to exclude data as well, using the `only` option, similar to how we'd specify certain routes for a resource.

```ruby
# posts_controller.rb
# ...
  def post_data
    post = Post.find(params[:id])
    #render json: PostSerializer.serialize(post)
    render json: post.to_json(only: [:title, :description, :id],
                              include: [ author: { only: [:name]}])
  end
```

We can use `only` both on the main object and the included objects.

**Top-tip:** Notice that we have to pass `author:` inside an array for `include` now that we are specifying additional options.

Reloading the `/posts/id/post_data` page now gives us something more like this:

```javascript
{
  id: 1,
  title: "A Blog Post By Stephen King",
  description: "This is a blog post by Stephen King. It will probably be a movie soon.",
  author: {
    name: "Stephen King"
  }
}
```

Which is exactly the data we need to get the job done.

### Responding To Requests With Different Formats

If we think about what we've been doing when we load `/posts/id/post_data`, we're really just requesting a `Post` resource, same as if we were on the Post `show` page. In fact, that's exactly what we're doing in AJAX on the Post `show` page, requesting the data for that page and replacing the values.

Given what we know about REST, and about DRY (don't repeat yourself), it seems like the `post_data` route and action are redundant. If we just want to request the post resource for `show`, we should be able to do that in one place.

In the desktop application world, we identify formats by *file extension*, so we know that `file.txt` is a plain text file, and `file.gif` is an awesome animated gif file.

![reaganaut](http://i.giphy.com/MCKQEmHkUyGf6.gif)

Rails provides us with a similar way to do this, [using `respond_to`](http://apidock.com/rails/ActionController/MimeResponds/InstanceMethods/respond_to).

If we go into our `show` action and add a `respond_to` block, we can specify what to render depending on if the request is looking for HTML or JSON.

```ruby
# posts_controller
# ...
  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @post.to_json(only: [:title, :description, :id],
                              include: [author: { only: [:name]}]) }
    end
  end
```

Now if we browse to `/posts/id`, we get the HTML page as expected. HTML is the default format for any request. We could also browse to `/posts/id.html`, and get the same thing.

But if we browse to `/posts/id.json`, we now get our serialized post in JSON form!

Now let's update the code in our `show.html.erb` to use the `show` route.

```erb
# posts/show.html.erb
# ...
$(function () {
  $(".js-next").on("click", function() {
    var nextId = parseInt($(".js-next").attr("data-id")) + 1;
    $.get("/posts/" + nextId + ".json", function(data) {
      $(".authorName").text(data["author"]["name"]);
      $(".postTitle").text(data["title"]);
      $(".postBody").text(data["description"]);
      // re-set the id to current on the link
      $(".js-next").attr("data-id", data["id"]);
    });
  });
});
```

Instead of doing a `$.get()` to `/posts/id/post_data`, we are now getting `/posts/id.json`. If we reload the page and click the `Next` button, everything still works and we don't have to change any of the code to extract the JSON values!

## Summary

We've seen how to use `to_json` to easily serialize an object, how to customize the serialized output, and how to modify our actions to respond with different formats.

You're probably thinking about that `to_json` call up there and noticing how it went from very simple to a little complex for just a few fields, and worrying about what you'll have to do when you're serializing a *big* object model? Don't worry. We'll get there.

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/using-to-json-ruby'>Using to_json</a> on Learn.co and start learning to code for free.</p>
