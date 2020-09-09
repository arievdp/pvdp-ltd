# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'smarter_csv'

p 'Creating farms'
farm = Farm.create!(code: "PQVV-SN54")

p 'Reading CSV'
data = SmarterCSV.process("./app/assets/csv/PQVV-SN54 ORANGE PQVV HERD PROFILE 20_21 PVDP APP-09 Sep 2020.csv")

p 'Creating animals'

data.each do |d|
  begin
    if d[:animal_birth_id_1].present?
      Animal.create!(
        farm: farm,
        birth_id: d[:animal_birth_id_1],
        cow_number: d[:animal_animal_id],
        birth_date: "20#{d[:animal_birth_id_1].match(/[0-9]{2}/)}",
        bw_value: d[:calf_bw_2_value],
        bw_reliability: d[:animal_bw_1_relability],
        pw_value: d[:animal_pw_value],
        pw_reliability: d[:animal_pw_reliability],
        a2_status: d[:animal_a2_status],
        fate: d[:"animal_custom:_animal_fate_(died)"],
        expected_calving_date: d[:expected_calving_date],
        calving_date: d[:animal_calving_date],
        calf_birth_id: d[:calf_birth_id_2],
        calf_birth_date: d[:calf_birth_date],
        calf_sex: d[:calf_sex],
        calf_fate: d[:calf_fate],
        dam_birth_id: d[:dam_official_id],
        dam_cow_number: d[:"dam_cow_no."],
        sire_birth_id: d[:sire_sire_id],
        sire_name: d[:sire_name],
        sex: "F"
      )
    end
  rescue ActiveRecord::RecordInvalid
    p 'duplicate records'
  end

  if d[:calf_birth_id_2].present?
    begin
      Animal.create!(
        farm: farm,
        birth_id: d[:calf_birth_id_2],
        # cow_number: d[:animal_animal_id],
        birth_date: d[:calf_birth_date],
        bw_value: d[:calf_bw_2_value],
        bw_reliability: d[:calf_bw_2_reliability],
        # pw_value: d[:animal_pw_value],
        # pw_reliability: d[:animal_pw_reliability],
        # a2_status: d[:animal_a2_status],
        sex: d[:calf_sex],
        fate: d[:calf_fate],
        # expected_calving_date: d[:expected_calving_date],
        # calving_date: d[:animal_calving_date],
        # calf_birth_id: d[],
        # calf_birth_date: d[:calf_birth_date],
        # calf_sex: d[:calf_sex],
        # calf_fate: d[:calf_fate],
        dam_birth_id: d[:animal_birth_id_1],
        dam_cow_number: d[:animal_animal_id],
        # sire_birth_id: d[:sire_sire_id],
        # sire_name: d[:sire_name],
      )
    rescue ActiveRecord::RecordInvalid
      p 'duplicate records'
    end
  end
end
