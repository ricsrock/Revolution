require 'rubaidh/form_builder_helper'

# Build a form using tables.
module Rubaidh
  module TabularForm
    class TabularFormBuilder < ActionView::Helpers::FormBuilder 
      (field_helpers - %w(check_box radio_button)).each do |selector| 
        src = <<-END_SRC 
          def #{selector}(field, options = {})
            field = field.to_s
            label_text, required = extract_tabular_options(field, options)
            generic_field(field, super, label_text)
          end 
        END_SRC
        class_eval src, __FILE__, __LINE__ 
      end
      
      %w(check_box radio_button).each do |selector|
        src = <<-END_SRC
          def #{selector}(field, options = {})
            field = field.to_s
            label_text, required = extract_tabular_options(field, options)
            generic_field(field, super, label_text, :required => required, :label => :after)
          end
        END_SRC
        class_eval src, __FILE__, __LINE__ 
      end
      
      def submit(text, options = {})
        generic_field(nil, @template.submit_tag(text, options))
      end
      
      def file_column_field(field, options = {})
        field = field.to_s
        label_text, required = extract_tabular_options(field, options)
        generic_field(field, @template.file_column_field(@object_name, field, options), label_text, :required => required)
      end
      
      def separator(new_section_name)
        <<-HTML
        </table></fieldset>
        <fieldset><legend>#{new_section_name}</legend><table>
        HTML
      end
      
      protected
      def generic_field(fieldname, field, label_text = nil, options = {})
        required = options[:required] ? td('*', :class => 'requiredField') : td('')
        unless label_text.blank?
          if options[:label] == :after
            tr(td('') + td(field + label(label_text, "#{@object_name}_#{fieldname}", true)) + required)
          else
            tr(
              td(label(label_text, "#{@object_name}_#{fieldname}")) +
              td(field) + required
            ) 
          end
        else # No label
          tr(td(field, :colspan => 2, :style => "text-align: right;") + required)
        end
      end
      
      def tr content, options = {}
        @template.content_tag 'tr', content, options
      end
      def td content, options = {}
        @template.content_tag 'td', content, options
      end
      def label text, for_field, after = false
        @template.content_tag 'label', "#{text}#{after ? '' : ':'}", :for => for_field
      end
      
      def extract_tabular_options field, options
        label_text = options.delete(:label) || field.to_s.humanize
        required = options.delete(:required) || false
        [label_text, required]
      end
    end 

    def tabular_form_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.last : {}
      legend = options.delete :legend
      if legend.blank?
        prefix = "<table>"
        postfix = "</table>"
      else
        prefix = "<fieldset><legend>#{legend}</legend><table>"
        postfix = '</table></fieldset>'
      end
      custom_form_for(
        TabularFormBuilder, prefix, postfix,
        form_tag(options.delete(:url) || {}, options.delete(:html) || {}),
        object_name, *args, &proc)
    end
    
    def tabular_remote_form_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.last : {}
      legend = options.delete :legend
      if legend.blank?
        prefix = "<table>"
        postfix = "</table>"
      else
        prefix = "<fieldset><legend>#{legend}</legend><table>"
        postfix = '</table></fieldset>'
      end
      custom_form_for(TabularFormBuilder, prefix, postfix, form_remote_tag(options), object_name, *args, &proc)
    end
  end
end