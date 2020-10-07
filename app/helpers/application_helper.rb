module ApplicationHelper
    # url: https://www.youtube.com/watch?v=cWYiAVMSHD4&ab_channel=Developer%27sBox
    def sortable(column, title = nil)
        title ||= column.titleize
        # css_class = column == sort_column ? "current #{sort_directions}" : nil
        direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
        link_to title, sort: column, direction: direction
    end 
end
