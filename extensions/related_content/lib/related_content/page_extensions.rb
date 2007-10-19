module RelatedContent::PageExtensions
  def self.included(base)
    base.class_eval do
      has_many :outgoing_relations, :class_name => "PageRelation", 
                :foreign_key => "from_id", :dependent => :destroy
      has_many :incoming_relations, :class_name => "PageRelation", 
                :foreign_key => "to_id", :dependent => :destroy
      
      has_many :related_pages, :through => :outgoing_relations, :source => :to, :class_name => "Page"
      
      before_save :create_relations
      
      attr_accessor :delete_relations, :add_relations
      
      # Needed to deal with drafts
      alias_method_chain :publish_associations, :related_content
      alias_method_chain :clone_associations, :related_content
      alias_method_chain :destroy_associations, :related_content
    end
  end
  
  # called when cloning a page into a draft
  def clone_associations_with_related_content(draft)
    clone_associations_without_related_content(draft)
    draft.add_relations = self.outgoing_relations.collect(&:to_id)
  end
  
  # called when publishing a draft
  def publish_associations_with_related_content
    publish_associations_without_related_content
    self.outgoing_relations.clear
    self.add_relations = self.draft.outgoing_relations.collect(&:to_id)
  end
  
  # called when destroying a draft
  def destroy_associations_with_related_content
    destroy_associations_without_related_content
    self.outgoing_relations.destroy_all
  end
  
  def create_relations
    if @delete_relations
      @delete_relations.each do |r|
        self.outgoing_relations.find_by_to_id(r).destroy
      end
    end
    if @add_relations
      @add_relations.each do |r|
        self.outgoing_relations.build(:to_id => r)
      end
    end
    @delete_relations = nil
    @add_relations = nil
  end
end