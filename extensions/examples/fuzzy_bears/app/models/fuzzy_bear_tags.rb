module FuzzyBearTags
  include Radiant::Taggable
  
  tag 'fuzzy_bears' do |tag|
    tag.expand
  end
  
  tag 'fuzzy_bears:each' do |tag|
    result = []
    FuzzyBear.find(:all).each do |bear|
      tag.locals.fuzzy_bear = bear
      result << tag.expand
    end
    result
  end
  
  tag 'fuzzy_bears:each:name' do |tag|
    tag.locals.fuzzy_bear.name
  end
  
  tag 'fuzzy_bears:each:weight' do |tag|
    tag.locals.fuzzy_bear.weight
  end
  
  tag 'fuzzy_bears:each:birthday' do |tag|
    format = tag.attr['format'] || '%m/%d/%Y'
    tag.locals.fuzzy_bear.birthday.strftime(format)
  end
  
end
