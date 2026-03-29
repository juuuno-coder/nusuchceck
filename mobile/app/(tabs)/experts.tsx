import { View, Text, ScrollView, Pressable } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { Ionicons } from "@expo/vector-icons";

// 전문가 카드 컴포넌트
function ExpertCard({ name, specialty, rating, reviews }: {
  name: string;
  specialty: string;
  rating: string;
  reviews: number;
}) {
  return (
    <Pressable
      className="bg-white rounded-3xl p-5 mb-4"
      style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}
    >
      <View className="flex-row items-center">
        <View className="w-14 h-14 bg-primary/10 rounded-full items-center justify-center mr-4">
          <Ionicons name="person" size={26} color="#3b82f6" />
        </View>
        <View className="flex-1">
          <Text className="text-heading-3 text-gray-900">{name}</Text>
          <Text className="text-caption text-gray-400 mt-0.5">{specialty}</Text>
        </View>
        <View className="items-end">
          <View className="flex-row items-center">
            <Ionicons name="star" size={14} color="#f59e0b" />
            <Text className="text-body font-semibold text-gray-900 ml-1">{rating}</Text>
          </View>
          <Text className="text-xs text-gray-400 mt-0.5">리뷰 {reviews}건</Text>
        </View>
      </View>

      {/* 태그 */}
      <View className="flex-row mt-3 gap-2">
        <View className="bg-gray-50 px-3 py-1 rounded-full">
          <Text className="text-xs text-gray-500">경력 인증</Text>
        </View>
        <View className="bg-primary/5 px-3 py-1 rounded-full">
          <Text className="text-xs text-primary">빠른 응답</Text>
        </View>
      </View>
    </Pressable>
  );
}

export default function ExpertsScreen() {
  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1 px-5" contentContainerStyle={{ paddingBottom: 40 }}>
        {/* 헤더 */}
        <View className="pt-4 pb-5">
          <Text className="text-2xl font-bold tracking-tight text-gray-900">전문가</Text>
          <Text className="text-body text-gray-400 mt-1">
            검증된 누수 전문가를 만나보세요
          </Text>
        </View>

        {/* 전문가 목록 */}
        <ExpertCard name="김누수" specialty="배관 누수 전문 | 경력 15년" rating="4.9" reviews={127} />
        <ExpertCard name="이점검" specialty="옥상 방수 전문 | 경력 12년" rating="4.8" reviews={98} />
        <ExpertCard name="박수리" specialty="화장실 누수 전문 | 경력 10년" rating="4.7" reviews={84} />

        {/* 매칭 안내 */}
        <View
          className="bg-white rounded-3xl p-5 items-center mt-2"
          style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}
        >
          <Text className="text-3xl mb-2">🔧</Text>
          <Text className="text-heading-3 text-gray-900 mb-1">맞춤 전문가 매칭</Text>
          <Text className="text-body text-gray-400 text-center">
            지역과 누수 유형에 맞는{"\n"}전문가를 매칭해드립니다
          </Text>
          <Pressable className="bg-primary rounded-full py-3.5 px-8 mt-4">
            <Text className="text-white font-semibold text-body">매칭 요청하기</Text>
          </Pressable>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
