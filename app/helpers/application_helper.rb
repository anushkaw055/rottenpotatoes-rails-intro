module ApplicationHelper
    def highlight_helper(sort_column)
        if(params[:sort_column]==sort_column)
            return 'hilite'
        end
        
        if(session[:sort_column]==sort_column)
            return 'hilite'
        end
        
    end

end
    
def sort_helper(sort_column)
        
        #Set sort direction
        sort_direction = params[:sort_direction]
        if(sort_direction=="asc")
            sort_direction="desc"
        else
            sort_direction = "asc"
        end
        
        #Set Display string
        link_display = ''
        if(sort_column=='title')
            link_display = 'Movie Title'
        elsif(sort_column == 'release_date')
            link_display = 'Release Date'
        end
        if(!@ratings_selected)
            @ratings_selected = session[:ratings]
        end
        
        link_to link_display, :sort_column => sort_column, :sort_direction => sort_direction, :ratings => @ratings_selected
end
    