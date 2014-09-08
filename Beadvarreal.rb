
#NEED TO THINK THROUGH HOW TO DEAL WITH INDELS

rmid = ARGV[0]
mut = Mutation.find_by recombine_id: "#{rmid}"

chr = mut.chromosome_id
snp = mut.position
chr = chr.to_i
snp = snp.to_i

padding = 50
bound1= snp-padding
bound2= snp+padding

puts bound1
puts bound2

#puts "Retrieving Variance from #{rmid}_B1"

tabix_base_command_1 = "tabix -h /resources/1000g/release_20130502/ALL.chr#{chr}.phase3_shapeit2_mvncall_integrated_v4.20130502.genotypes.vcf.gz "
bead1_interval = " #{chr}:#{bound1}-#{snp}|"
vcftools_base_command_1 = " vcftools --vcf - --freq -c"
tabix_exec_command_1 = tabix_base_command_1 + bead1_interval + vcftools_base_command_1
#puts "running #{tabix_exec_command}\n"
tabix_io_1 = IO.popen(tabix_exec_command_1)

vcf_freq_lines_1 = tabix_io_1.readlines
filtered_vcf_file_handle_1 = 'tmp.filtered.vcf'
tmp_file_1 = File.open(filtered_vcf_file_handle_1, 'w')
vcf_freq_lines_1.each{|r|tmp_file_1.write(r)}
puts vcf_freq_lines_1

#delete header
vcf_freq_lines_1.delete_at(0)

#get count of MA
puts "MA count"
count = vcf_freq_lines_1.count
puts count

#Get the maximum MAF
array_MAF = []
vcf_freq_lines_1.each {|a| array_MAF.push(a.split(":").last)}
array_MAF_flt = array_MAF.collect{|s| s.to_f}
puts "Max MAF"
puts array_MAF_flt.max

#print hash of variant count, maximum MAF, and the total array of MAF

bead_variance = {}
	bead_variance["variant_count"] = "#{count}"
	bead_variance["max_MAF"] = array_MAF_flt.max
	bead_variance["MAF_array"] = array_MAF_flt.sort

puts "Hash"
print bead_variance


# #puts "Retrieving Variance from #{rmid}_B2"

# tabix_base_command_2 = "tabix -h /resources/1000g/release_20130502/ALL.chr#{chr}.phase3_shapeit2_mvncall_integrated_v4.20130502.genotypes.vcf.gz "
# bead2_interval = " #{chr}:#{snp}-#{bound2}|"
# vcftools_base_command_2 = " vcftools --vcf - --freq -c"
# tabix_exec_command_2 = tabix_base_command_2 + bead2_interval + vcftools_base_command_2
# #puts "running #{tabix_exec_command}\n"
# tabix_io_2 = IO.popen(tabix_exec_command_2)

# vcflines_2 = tabix_io_2.readlines
# filtered_vcf_file_handle_2 = 'tmp.filtered.vcf'
# tmp_file_2 = File.open(filtered_vcf_file_handle_2, 'w')
# vcflines_2.each{|r|tmp_file_2.write(r)}
# puts vcflines_2
