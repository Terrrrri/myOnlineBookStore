class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # 如果用户未登录，使用匿名用户

    if user.admin?
      can :manage, :all # 管理员可以管理所有资源
    else
      can :read, Book # 普通用户只能读取书籍

    end
  end
end
