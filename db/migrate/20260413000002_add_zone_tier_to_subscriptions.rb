class AddZoneTierToSubscriptions < ActiveRecord::Migration[7.1]
  def up
    # zone tier: 3 (월 99,000원 구역 선점 플랜)
    # enum 변경 없이 integer 값 3으로 추가됨 (Rails enum에서 선언만 추가하면 됨)
  end

  def down
  end
end
