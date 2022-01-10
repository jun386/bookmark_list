<template>
  <v-app id="app">
    <v-container style="height: 1000px; max-width: 2400px; padding: 0 20px;">
      <v-layout>
        <v-flex xs2 style="justify-content: center; padding: 20px 5px 0 5px">
          <h3>サイドメニュー表示</h3>
        </v-flex>

        <v-flex xs8>
          <div style="width: 100%; margin: 5px 0 20px 0; display: flex; justify-content: center;">
            <h1>Bookmark 一覧</h1>
          </div>
          <v-layout>
            <v-flex row wrap style="justify-content: center;">

            <!-- v-forで bookmarkList の配列の中身を取り出してbookmarkに代入し繰り返す -->
              <v-card v-for="bookmark in bookmarkList" :key="bookmark.id" style="width: 100%">
                <v-card-title primary-title style="margin-bottom: 15px; width: 100%; padding-bottom: 10px;">
                  <div style="width: 100%;">
                    <div class="headline mb-0" style="display: flex; justify-content: space-between; width: 100%">
                      <p style="font-size: 18px;">
                        {{ bookmark.title }}  <!-- タイトルを表示 -->
                      </p>
                    </div>
                    <v-divider></v-divider>
                    <div style="font-size: 16px; display: flex; justify-content: space-between; width: 100%">
                      <div>
                        #{{ bookmark.category }}  <!-- カテゴリーを表示 -->
                      </div>
                    </div>
                  </div>
                </v-card-title>
              </v-card>

            </v-flex>
          </v-layout>
        </v-flex>

        <v-flex xs2>
          <v-btn style="margin: 20px 0 40px 0;">
            Bookmarkを追加する  <!-- 追加するモーダルを表示させるボタン（後に実装） -->
          </v-btn>
          <p style="margin-right: 30px">- Bookmark List -</p>
          <!-- 右側にもリストとしてブックマークをタイトルのみ一覧表示させる -->
          <ul v-for="bookmark in bookmarkList" :key="bookmark.id" style="list-style: none; margin-right: 30px">
            <li style="margin-top: 10px;">
              <p>{{ bookmark.title }}</p>  <!-- タイトルを表示させる -->
            </li>
            <hr>
          </ul>

        </v-flex>
      </v-layout>
    </v-container>
  </v-app>
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      bookmarkList: ['',''],  // 空配列を用意
    }
  },
  mounted () {
    this.setBookmark(); // setBookmark() を呼び出す
  },
  methods: {
    setBookmark: function () {
      axios.get('/api/bookmarks') // axiosを使ってデータを取得
      .then(response => {
        this.bookmarkList = response.data // axiosで呼び出したAPIの情報をbookmarkListに代入
        }
      );
    },
  }
}
</script>