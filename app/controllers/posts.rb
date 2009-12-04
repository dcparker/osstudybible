class Posts < Application
  namespace :posts

  get do
    template :index, :posts => Post.all
  end

  post do
    if post = Post.create(params[:post])
      redirect url(:post, post)
    else
      redirect url(:posts)
    end
  end

  path :post => ':id' do

    # setup do |id|
    #   template.title = "Hello World!"
    #   template.post = Post.get(id)
    # end

    get do |id|
      template.post = Post.get(id)
      template.url = url(:formatted_post, id, 'xml')
      template :show
    end

    get :formatted_post => /\.([\w]+)/ do |id,format|
      template.post = Post.get(id)
      content_type 'application/xml'
      template :show_xml
    end

    delete do |id|
      template.post = Post.get(id)
      if template.post.destroy
        redirect url(:posts)
      else
        status 500
        "There was an error deleting Post ##{template.post.id}!"
      end
    end

  end

end
