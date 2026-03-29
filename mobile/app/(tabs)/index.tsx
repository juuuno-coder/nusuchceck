import { View, Text, Pressable, ScrollView } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { Ionicons } from "@expo/vector-icons";

export default function HomeScreen() {
  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1 px-5" contentContainerStyle={{ paddingBottom: 40 }}>
        {/* 헤더 */}
        <View className="pt-4 pb-5">
          <Text className="text-2xl font-bold tracking-tight text-gray-900">누수체크</Text>
          <Text className="text-body text-gray-400 mt-1">
            AI로 빠르게 누수를 점검하세요
          </Text>
        </View>

        {/* AI 빠른 점검 CTA */}
        <Pressable
          className="bg-primary rounded-3xl p-5 mb-4"
          style={{ shadowColor: '#3b82f6', shadowOpacity: 0.2, shadowRadius: 12, shadowOffset: { width: 0, height: 4 }, elevation: 4 }}
        >
          <View className="flex-row items-center mb-3">
            <View className="w-10 h-10 bg-white/20 rounded-full items-center justify-center mr-3">
              <Ionicons name="flash" size={22} color="#ffffff" />
            </View>
            <Text className="text-white text-heading-3">AI 빠른 점검</Text>
          </View>
          <Text className="text-white/80 text-body">
            사진을 찍으면 AI가 누수 여부를 즉시 분석해드립니다
          </Text>
          <View className="flex-row items-center mt-4">
            <Text className="text-white font-semibold text-body">시작하기</Text>
            <Ionicons name="arrow-forward" size={16} color="#ffffff" style={{ marginLeft: 4 }} />
          </View>
        </Pressable>

        {/* 빠른 메뉴 */}
        <View className="flex-row gap-3 mb-6">
          <Pressable className="flex-1 bg-white rounded-3xl p-5 items-center" style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}>
            <View className="w-12 h-12 bg-primary/10 rounded-2xl items-center justify-center mb-2">
              <Ionicons name="camera-outline" size={24} color="#3b82f6" />
            </View>
            <Text className="text-caption text-gray-700">사진 점검</Text>
          </Pressable>
          <Pressable className="flex-1 bg-white rounded-3xl p-5 items-center" style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}>
            <View className="w-12 h-12 bg-primary/10 rounded-2xl items-center justify-center mb-2">
              <Ionicons name="document-text-outline" size={24} color="#3b82f6" />
            </View>
            <Text className="text-caption text-gray-700">점검 내역</Text>
          </Pressable>
          <Pressable className="flex-1 bg-white rounded-3xl p-5 items-center" style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}>
            <View className="w-12 h-12 bg-primary/10 rounded-2xl items-center justify-center mb-2">
              <Ionicons name="call-outline" size={24} color="#3b82f6" />
            </View>
            <Text className="text-caption text-gray-700">전문가 상담</Text>
          </Pressable>
        </View>

        {/* 전문가 찾기 배너 */}
        <Pressable
          className="bg-white rounded-3xl p-5 mb-6 flex-row items-center"
          style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}
        >
          <View className="w-12 h-12 bg-green-50 rounded-2xl items-center justify-center mr-4">
            <Ionicons name="people" size={24} color="#22c55e" />
          </View>
          <View className="flex-1">
            <Text className="text-heading-3 text-gray-900">전문가 찾기</Text>
            <Text className="text-caption text-gray-400 mt-0.5">검증된 누수 전문가를 만나보세요</Text>
          </View>
          <Ionicons name="chevron-forward" size={20} color="#d1d5db" />
        </Pressable>

        {/* 최근 점검 */}
        <View>
          <Text className="text-[11px] uppercase tracking-[0.15em] font-medium text-gray-400 mb-2 ml-1">최근 점검</Text>
          <View className="bg-white rounded-3xl p-5 items-center" style={{ shadowColor: '#000', shadowOpacity: 0.05, shadowRadius: 10, shadowOffset: { width: 0, height: 2 }, elevation: 2 }}>
            <Text className="text-4xl mb-2">📋</Text>
            <Text className="text-body text-gray-400">아직 점검 내역이 없습니다</Text>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
