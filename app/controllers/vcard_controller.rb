class VcardController < ApplicationController
    
before_filter :login_required
    
    def get_card
        person = Person.find(params[:id])
        send_data person.to_vcard, :filename => "person_#{person.id}.vcf"
    end
    
    def get_batch_of_cards
        batch_of_cards = ''
        @team = Team.find(params[:id])
        @team.distinct_members.each do |person|
            batch_of_cards << person.to_vcard
        end
        send_data batch_of_cards, :filename => "batch_of_cards.vcf"
    end
    
    def get_group_cards
        batch_of_cards = ''
        @group = Group.find(params[:id])
        @group.people.each do |person|
            batch_of_cards << person.to_vcard
        end
        send_data batch_of_cards, :filename => "batch_of_cards.vcf"
    end
    
    def get_smart_group_cards
        batch_of_cards = ''
        @smart_group = SmartGroup.find(params[:id])
        @smart_group.found_people.each do |person|
            batch_of_cards << person.to_vcard
        end
        send_data batch_of_cards, :filename => "smart_group_#{@smart_group.id}_cards.vcf"
    end
    
    
    
end
