require_relative 'TableAction'

class ValidArgs
  def self.first_valid(args, n)
    if args.length > n
      return false 
    else
      return true
    end
  end

  def self.equal_valid(args, n)
    if args.length == n
      return true
    else
      return false
    end
  end

  def self.player_valid(args)
    args.each do | player |
      if User.find_by(player_name: player)
        next
      else
        return false
        break
      end
    end
    return true
  end
end

