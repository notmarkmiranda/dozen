class SettingDecorator < ApplicationDecorator
  delegate_all

  FORM_FIELDS = {
    'COUNTED_GAMES_FOR_STANDINGS' => {
      label: 'Percentage of games to count for playoffs',
      description: 'Random description for things'
    }
  }


  def form_label_and_field(form, setting_name)
    label_text = FORM_FIELDS[self.name][:label]
    label = form.label :value, label_text
    field = form.text_field :value, class: 'form-control'
    label + field
  end
end
