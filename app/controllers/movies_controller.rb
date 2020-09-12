class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def get_unique_ratings
    return Movie.uniq.pluck(:rating)
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    sort_column = params[:sort_column]
     if(!sort_column and session[:sort_column])
      sort_column = session[:sort_column]
     else  
      sort_column ||='release_date'
    end
    
    session[:sort_column] = sort_column
    sort_direction = params[:sort_direction]
    
    #Below is via session else default sort direction implementation
    if(!sort_direction and session[:sort_direction])
      sort_direction = session[:sort_direction]
    else
      sort_direction ||= "desc"
    end
    session[:sort_direction] = sort_direction
    
    #@movies = Movie.order(sort_column)
    @all_ratings = get_unique_ratings
    @selected_rating = params[:ratings]
    
    if(!@selected_rating and session[:ratings] )
      @selected_rating=session[:ratings]
      @selected_rating_keys = session[:ratings].keys
    else
      @selected_rating_keys||=@all_ratings
    end
    

    if(@selected_rating)
      @selected_rating_keys = @selected_rating.keys
    end

    session[:ratings] = @selected_rating

    @movies = Movie.where(rating: @selected_rating_keys).order(sort_column+" "+ sort_direction)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end