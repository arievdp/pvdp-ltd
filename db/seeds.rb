# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'smarter_csv'

f = Farm.create(code: "PQVV-SN54")

data = SmarterCSV.process("./app/assets/csv/PQVV-SN54 ORANGE PQVV HERD PROFILE 20_21 PVDP APP-09 Sep 2020.csv")

data.each do |d|
  Animal.new(
    farm_id: f,
    birth_id: d[:animal_birth_id],
    tag_number: d[:animal_animal_id],
    birth_date: d[:calf_birth_date],
    bw_value: d[:animal_bw_1_value],
    bw_reliability: d[:animal_bw_1_relability],
    pw_value: d[:animal_pw_value],
    pw_reliability: d[:animal_pw_reliability],
    a2_status: d[:animal_a2_status],
    expected_calving_date: d[:pre_calving_expected_calving_date],
    calving_date: d[:animal_calving_date],
    dam_id: d[:dam_official_id],
    dam_tag_number: d[:"dam_cow_no."],
    sire_id: d[:sire_sire_id],
    sire_name: d[:sire_name],
    sex: d[:animal_calving_date],
    fate: d[:calf_fate],
    )
end
