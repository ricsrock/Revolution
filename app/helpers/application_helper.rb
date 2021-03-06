module ApplicationHelper
  
  
  # not with remote: true, just a standard link that points to nowhere
  # the js is watching this link's class
  # this helper builds up entire fields_for instance around the new object and assigns all of it to the 'fields' variable
  # 'fields' is sent to the js via data: { fields: fields }
  def link_to_add_fields(name, f, association)
      new_object = f.object.send(association).klass.new
      id = new_object.object_id
      fields = f.fields_for(association, new_object, child_index: id) do |builder|
        render(association.to_s.singularize + "_fields", f: builder)
      end
      link_to(name, '#', class: "add_fields small round button success", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
  def four_up_two_up_widget_box(title, &block)
    raw "<div class='widget-box'><div class='widget-title'><h4>" + title + "</h4></div><ul class='block-grid four-up mobile-two-up'>" + capture(&block) + "</ul></div>"
  end
  
  def widget_box(title, &block)
    raw "<div class='widget-box'><div class='widget-title'><h4>" + title + "</h4></div>" + capture(&block) + "</div>"
  end
  
  def make_row(&block)
    raw "<div class='row'>" + capture(&block) + "</div>"
  end
  
  def make_col(columns, &block)
    raw "<div class= '#{columns} columns'>" + capture(&block) + "</div>"
  end
  
  def icon(name, size=1)
      #icon("camera-retro")
      #<i class="icon-camera-retro"></i> 

      html = "<i class='icon-#{name}' "
      html += "style='font-size:#{size}em' "
      html += "></i>"
      html.html_safe
    end
    
    def foundicon(name, size=1)
        #icon("camera-retro")
        #<i class="icon-camera-retro"></i> 

        html = "<i class='#{name}' "
        html += "style='font-size:#{size}em' "
        html += "></i>"
        html.html_safe
      end
    
    def button_icon(text, url, name, size=1.5, *options)
      #button_icon("Camera Retro button", "#","refresh",1)
  		#<a class="button refresh" href="#"><i style="font-size:1.5em" class="icon-refresh"></i> Camera Retro button</a>
      class_to_add = "button #{name}"
      options.each { |opt| class_to_add += " #{opt}" } if !options.empty?
      link_to(url, html_options = { :class => class_to_add }) {icon(name, size) + " " + text}
    end

    def link_icon(text, url, name, size=1, *options)
      #link_icon("Camera Retro button", "#","refresh",1)
      # <a class="refresh" href="#"><i style="font-size:1.5em" class="icon-refresh"></i> Camera Retro button</a>

      class_to_add = "#{name}"
      options.each { |opt| class_to_add += " #{opt}" } if !options.empty?
      link_to(url, html_options = { :class => class_to_add }) {icon(name, size) + " " + text}
    end
    
    def link_foundicon(text, url, name, size=1, *options)
      #link_icon("Camera Retro button", "#","refresh",1)
      # <a class="refresh" href="#"><i style="font-size:1.5em" class="icon-refresh"></i> Camera Retro button</a>

      class_to_add = ""
      options.each { |opt| class_to_add += " #{opt}" } if !options.empty?
      link_to(url, html_options = { :class => class_to_add }) {foundicon(name, size) + " " + text}
    end
    
    def flash_class(name)
      case name
      when :notice
        "success"
      when :error
        "alert"
      when :alert
        "alert"
      when :secondary
        "secondary"
      when :warning
        "warning"
      else
        ""
      end
    end
    
    def which_icon(name)
      case name
      when :notice
        "icon-ok-sign"
      when :error
        "icon-exclamation-sign"
      when :alert
        "icon-exclamation-sign"
      else
        "icon-info-sign"
      end
    end
end
