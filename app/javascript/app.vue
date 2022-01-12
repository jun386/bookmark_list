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

            <!-- bookmark の表示部分 -->
              <v-card v-for="bookmark in bookmarkList" :key="bookmark.id" style="width: 100%">
                <v-card-title primary-title style="margin-bottom: 15px; width: 100%; padding-bottom: 10px;">
                <div style="width: 100%;">
                    <div class="headline mb-0" style="display: flex; justify-content: space-between; width: 100%">
                      <p style="font-size: 18px;">
                        {{ bookmark.title }}  <!-- タイトルを表示 -->
                      </p>

                      <!-- 編集用フォームのモーダルを開くボタン -->
                      <v-tooltip right>
                        <template v-slot:activator="{ on }">
                          <!-- togglePutModalに編集するbookmarkのIDを引数で渡す -->
                          <v-btn light v-on="on" @click="togglePutModal(bookmark.id)" style="margin-bottom: 8px">
                            <span class="material-icons" style="margin-right: 4px;">create</span>
                          </v-btn>
                        </template>
                        <span>編集する</span>
                      </v-tooltip>

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
          <v-btn @click="togglePostModal()" style="margin: 20px 0 40px 0;">
            Bookmarkを追加する
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
    <v-dialog v-model="dialogPostFlag" width="500px" persistent>
      <v-card>
        <v-card-title class="headline blue-grey darken-3 white--text" primary-title>
          ブックマーク新規投稿
        </v-card-title>

        <!-- タイトルの入力フォーム -->
        <v-text-field v-model="postTitle" :counter="50" label="Title" required style='margin:20px;'></v-text-field> 

        <!-- URLの入力フォーム -->
        <v-text-field v-model="postUrl" label="URL" required style='margin:20px;'></v-text-field> 

        <!-- カテゴリーの入力フォーム -->
        <v-text-field v-model="postCategory" :counter="50" label="Category" required style='margin:20px;'></v-text-field>

        <!-- カテゴリーを選択できるプルダウン (categoriesForEditの配列の中身を表示) -->
        <v-select v-model='postCategory' :items="categoriesForEdit" label="Category [select]" style='margin:20px;'></v-select>

        <v-divider></v-divider>
        <v-card-actions>

          <!-- モーダルを閉じる キャンセルボタン -->
          <v-btn dark @click="togglePostModal">
            Cancel
          </v-btn>

          <v-spacer></v-spacer>

          <!-- postBookmark を呼んで値を送信 (submitボタン) -->
          <v-btn @click="postBookmark">
            Add Bookmark
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="dialogPutFlag" width="500px" persistent>
      <v-card>
        <v-card-title class="headline orange darken-4 white--text" primary-title>
          ブックマーク編集
        </v-card-title>

        <v-text-field v-model="putTitle" :counter="50" label="Title" required style='margin:20px;'></v-text-field> 
        <v-text-field v-model="putUrl" label="URL" required style='margin:20px;'></v-text-field> 
        <v-text-field v-model="putCategory" :counter="50" label="Category" required style='margin:20px;'></v-text-field> 
        <v-select v-model='putCategory' :items="categoriesForEdit" label="Category [select]" style='margin:20px;'></v-select>

        <v-divider></v-divider>
        <v-card-actions>
          <!-- キャンセルボタン cancelメソッドを呼び出す -->
          <v-btn dark @click="cancel">
            Cancel
          </v-btn>

          <v-spacer></v-spacer>

          <!-- 更新ボタン putBookmarkメソッドを呼び出し submit -->
          <v-btn @click="putBookmark">
            Update
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

  </v-app>
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      bookmarkList: ['',''],  // 空配列を用意
      allData: ['',''],       // bookmarkの値を全て代入する空配列をもう一つ用意
      categories: ['All'],    // カテゴリーを代入する配列 (検索機能で使用)
      categoriesForEdit: [],  // カテゴリーを代入する配列 (新規投稿や編集フォームで使用)
      category: 'ALL',        // bookmarkのカテゴリー 初期値は'ALL'

      dialogPostFlag: false,  // モーダル表示：初期値をfalseに設定
      postTitle: "",          // フォームの中身の初期値は空
      postUrl: "",            // フォームの中身の初期値は空
      postCategory: "",       // フォームの中身の初期値は空

      dialogPutFlag: false,  //編集用モーダルウィンドウ
      putTitle: '',
      putUrl: '',
      putCategory: '',
    }
  },
  mounted () {
    this.setBookmark(); // setBookmark() を呼び出す
  },
  methods: {
    setBookmark: function () {
      axios.get('/api/bookmarks') // axiosを使ってデータを取得
      .then(response => {
        this.allData = response.data
        this.bookmarkList = this.allData
        }
      );
      this.listCategories();
    },

    listCategories: function() {
      this.categories = []         // 検索で表示するカテゴリーの選択メニュー
      this.categoriesForEdit = []  // 新規投稿や編集のフォームに表示する選択メニュー
      this.categories.push('ALL')  // `ALL`を配列に追加してメニューの一番上に表示させる

      // 配列の要素の数だけ反復処理
      for (i=0; i<this.allData.length; i++) {
        // 保存されたカテゴリーの文字列が、i 番目の　allData　のカテゴリーの何文字目で一致するかを返し、
        // 一致しない場合は -1 を返す
        // そして結果が -1 で true である場合に処理を行う
        if (this.categories.indexOf(this.allData[i].category) == -1) {
          // つまり新しいカテゴリーが保存された時それぞれの配列の中に値を push する
          this.categories.push(this.allData[i].category)
          this.categoriesForEdit.push(this.allData[i].category)
        }
      }
    },

    togglePostModal: function() {
      // モーダルの開閉状態を操作する。(ONとOFFを切り替える)
      this.dialogPostFlag = !this.dialogPostFlag
    },

    postBookmark: function() {
      // axiosを使って /api/bookmarks コントローラーの create アクションにデータを送信
      // 第2引数でカラムにそれぞれフォームで受け取ったデータを渡す
      axios.post('/api/bookmarks', {title:this.postTitle,url:this.postUrl,category:this.postCategory})
        .then(response => {
          this.setBookmark();      // setBookmark()を呼び出す
          this.postTitle = ''      // postTitleの中身を空の状態に戻す
          this.postUrl = ''        // postUrlの中身を空の状態に戻す
          this.postCategory = ''   // postCategoryの中身を空の状態に戻す
        }
      );
      this.dialogPostFlag = !this.dialogPostFlag  // モーダルを閉じる
    },

    togglePutModal: function(id) {  // 編集するbookmarkのIDを受け取る
      this.id = id

      // axiosを使って編集対象となるbookmarkの内容を取得し、フォームに表示させる
      axios.get(`/api/bookmarks/${this.id}.json`)
        .then(response => {
          this.putTitle = response.data.title
          this.putUrl = response.data.url
          this.putCategory = response.data.category
        }
      );
      // モーダルの開閉状態を操作
      this.dialogPutFlag = !this.dialogPutFlag
    },

    putBookmark: function() {
      axios.put(`/api/bookmarks/${this.id}`, {title:this.putTitle, url:this.putUrl, category:this.putCategory})
        .then(response => {
          this.setBookmark();
        }
      );
      this.dialogPutFlag = !this.dialogPutFlag
    },

    cancel: function() {
      this.dialogPutFlag = !this.dialogPutFlag
    },
  }
}
</script>