module  PUBGRateBot
  module EmbedCreator
    class << self
      def add_command(user)
        embed = Discordrb::Webhooks::Embed.new(title: "Add User", color: 0x00FFFF, description: "Success")
        embed.add_field(
            name: "Player name",
            value: "#{user.detail.player_name}",
            inline: true,
            )
        embed.add_field(
            name: "Account ID",
            value: "#{user.detail.account_id}",
            inline: true,
            )
        embed.add_field(
            name: "Registration date",
            value: "#{user.created_at}",
            inline: true,
            )
        embed
      end

      def rate_command(user, rank_points)
        embed = Discordrb::Webhooks::Embed.new(title: "PUBGRate", color: 0x00FFFF, description: "#{user.detail.player_name}'s rate")
        embed.add_field(
            name: "TPP solo",
            value: rank_points[0].to_s,
            inline: true,
            )
        embed.add_field(
            name: "TPP duo",
            value: rank_points[2].to_s,
            inline: true,
            )
        embed.add_field(
            name: "TPP squad",
            value: rank_points[4].to_s,
            inline: true,
            )
        embed.add_field(
            name: "FPP solo",
            value: rank_points[1].to_s,
            inline: true,
            )
        embed.add_field(
            name: "FPP duo",
            value: rank_points[3].to_s,
            inline: true,
            )
        embed.add_field(
            name: "FPP squad",
            value: rank_points[5].to_s,
            inline: true,
            )
        embed
      end
    end
  end
end
