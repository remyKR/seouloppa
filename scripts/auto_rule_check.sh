#!/bin/bash

# 자동 법칙 체크 래퍼 스크립트
# 모든 개발 명령어 실행 전 자동으로 법칙 체크

COMMAND="$1"
shift
ARGS="$@"

echo "🔴 자동 법칙 체크 실행 중..."

# 법칙 강제 실행 스크립트 실행
if ! ./scripts/rule_enforcement.sh; then
    echo ""
    echo "🚨 법칙 위반으로 인해 명령어 실행이 차단되었습니다."
    echo "명령어: $COMMAND $ARGS"
    echo ""
    echo "다음 중 선택하세요:"
    echo "1. 법칙을 준수하도록 수정 후 재시도"
    echo "2. 사용자 승인 요청"
    echo "3. 명령어 실행 포기"
    exit 1
fi

echo "✅ 법칙 준수 확인 완료. 명령어 실행..."

# 원래 명령어 실행
case "$COMMAND" in
    "flutter_run")
        flutter run $ARGS
        ;;
    "flutter_build")
        flutter build $ARGS
        ;;
    "pub_get")
        flutter pub get $ARGS
        ;;
    "pod_install")
        cd ios && pod install && cd ..
        ;;
    *)
        echo "알 수 없는 명령어: $COMMAND"
        exit 1
        ;;
esac