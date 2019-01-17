# require_relative '../models/mode'
# require_relative '../models/user'
# 
# module ValidArgs
#   class << self
#     def is_args_larger_than_number?(args, number)
#       return true if args.length > number
#       return false
#     end
# 
#     def is_args_smaller_than_number?(args, number)
#       return true if args.length < number
#       return false
#     end
# 
#     def is_args_equal_number?(args, number)
#       return true if args.length == number
#       return false
#     end
# 
#     def is_exist_mode?(mode)
#       return true if Mode.find_by(play_mode: mode)
#       return false
#     end
# 
#     def is_exist_player?(players_name)
#       players_name.each do |player_name|
#         return false if User.find_by(player_name: player_name).nil?
#       end
#       return true
#     end
#   end
# end