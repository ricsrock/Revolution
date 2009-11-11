# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def toggle_group_links(action)
    update_page do |page|
      page.select("##{@instance.dom_id}").each do |item|
        page.send action, item
      end
    end
  end
  def toggle_instance_links(action)
    update_page do |page|
      page.select('#new_instance_wrap').each do |item|
        page.send action, item
      end
    end
  end
  
  def toggle_person_links(action)
    update_page do |page|
      page.select('#new_person_wrap').each do |item|
        page.send action, item
      end
    end
  end
  
  def toggle_associate_links(action)
    update_page do |page|
      page.select('#new_associate_wrap').each do |item|
        page.send action, item
      end
    end
  end
  
  def toggle_email_links(action)
     update_page do |page|
       page.select('#new_email_wrap').each do |item|
         page.send action, item
       end
     end
   end
   
   def toggle_phone_links(action)
      update_page do |page|
        page.select('#new_phone_wrap').each do |item|
          page.send action, item
        end
      end
    end
    
    def toggle_search_links(action)
        update_page do |page|
          page.select('#search_wrap').each do |item|
            page.send action, item
          end
        end
      end
      
      def toggle_tag_links(action)
          update_page do |page|
            page.select('#new_tag_wrap').each do |item|
              page.send action, item
            end
          end
        end
        
        def toggle_add_people_links(action)
            update_page do |page|
              page.select('#search-panel').each do |item|
                page.send action, item
              end
            end
          end
          
          def toggle_location_list(action)
              update_page do |page|
                page.select('#location_list').each do |item|
                  page.send action, item
                end
              end
            end
  
        def picture_for(person, size = :medium)
            if person.picture
            person_image = person.picture.public_filename(size)
            image_tag(person_image, :border => 0)
            else
            image_tag("blank-picture-#{size}.png")
            end
        end
        
        def comments_for(contact)
            if current_user.has_role?("confidential")
                contact.comments rescue nil
            else
                'Comments marked as confidential.'
            end
        end
        
        def gradient_box(inside_stuff)
           box = '<div class="roundedcornr_box_362030"><div class="roundedcornr_top_362030"><div>&nbsp;</div></div><div class="roundedcornr_content_362030">'
           box << inside_stuff
           box << '</div> <div class="roundedcornr_bottom_362030"><div></div></div></div></div></div>' 
        end
        
        def cool_button(text,controller,action)
            link_to '<span>'+text+'</span>', {:controller => controller, :action => action}, {:class => "button"}
        end
        
        def cool_button_id(text,controller,action,id)
            link_to '<span>'+text+'</span>', {:controller => controller, :action => action, :id => id}, {:class => "button"}
        end
  
        def main_menu
         buttons = [
         ['/dashboard', "My Dashboard"],
         ["/people/show/#{session[:sticky_person]}", "#{render :partial => "shared/access_denied" unless session[:sticky_person].nil?}"],
         ['/households/list', "Households"],
         ['/checkin', "Checkin"],
         ['/events/manage', "Manage Events"],
         ['/ministries/manage', "Manage Ministries"],
         ['/groups/tree_view', "Manage Groups"],
         ]
         content = ""
         buttons.each do |button|
             content << if request.path.include?(button[0]) or (request.path.include?(button[2]) unless button[2].nil?)
                 content_tag('li', content_tag('a', button[1], :href => nil), :class => 'activestate')
                 else
                 content_tag('li', content_tag('a', button[1], :href => button[0]), :class => nil)
                 end << "\n"
             end
             content_tag('ul', content, :id => "list-of-buttons")
        end
        
        def menu_class(controller_name)
            controller.controller_name == controller_name ? 'activestate' : ''
        end
        
        def person_tab_class(tab_name,instance_variable=nil)
            if instance_variable == tab_name
                'activestate'
            elsif instance_variable.nil? && current_user.preferences[:person_tab] == tab_name
                'activestate'
            else
                ''
            end
        end
        
        def group_tab_class(tab_name,instance_variable=nil)
            if instance_variable == tab_name
                'activestate'
            elsif instance_variable.nil? && current_user.preferences[:group_tab] == tab_name
                'activestate'
            else
                ''
            end
        end
        
        def household_tab_class(tab_name,instance_variable=nil)
            if instance_variable == tab_name
                'activestate'
            elsif instance_variable.nil? && current_user.preferences[:household_tab] == tab_name
                'activestate'
            else
                ''
            end
        end
        
        def organization_tab_class(tab_name,instance_variable=nil)
            if instance_variable == tab_name
                'activestate'
            elsif instance_variable.nil? && current_user.preferences[:organization_tab] == tab_name
                'activestate'
            else
                ''
            end
        end
        
        def to_percent(integer_a, integer_b)
          return nil if integer_a.nil? or integer_b.nil?
          number_to_percentage (integer_b.to_f/integer_a.to_f) * 100, :precision => 0
        end
  
  def remove_child_link(name, f)
    f.hidden_field(:_delete) + link_to_function(name, "remove_fields(this)")
  end

  def add_child_link(name, f, method)
    fields = new_child_fields(f, method)
    link_to_function(name, h("insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\")"))
  end

  def new_child_fields(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f
    form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end
  end
end
