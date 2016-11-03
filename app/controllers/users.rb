class MakersBnB < Sinatra::Base

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/sign_up' do
    @user = User.create(first_name: params[:first_name],
                last_name: params[:last_name],
                email: params[:email],
                mobile_number: params[:mobile_number],
                password: params[:password],
                password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      flash.keep[:notice] = "Welcome, #{@user.first_name}"
      redirect('/home')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'/users/new'
    end
  end

  get '/users/profile' do
    @available_dates = Avdate.all(is_available: true)
    @user_listings = Listing.all(user_id: current_user.id)
    @requests_made = Request.all(user_id: current_user.id)
    # if @requests_made.empty?
    #   flash.now[:errors] = ['You currently have no trips planned']
    #   erb(:'/users/profile')
    # end

    @requests_received = Request.all(user_id: current_user.id)
    # if @requests_received.empty?
    #   flash.now[:errors] = ['You have no booking requests']
    #   erb(:'/users/profile')
    # end
    erb(:'/users/profile')
  end
end
