<template>
  <v-app id="app">
    <Loading v-show="isLoading"></Loading>
    <v-container style="height: 1000px; max-width: 2400px; padding: 0 20px;">
      <v-layout>
        <Search :searchWord="searchWord" :category="category" :categories="categories" @change-search-word="changeSearchWord" @change-search-category="changeSearchCategory" @search="abstruct"></Search>

        <v-flex xs8>
          <div style="width: 100%; margin: 5px 0 20px 0; display: flex; justify-content: center;">
            <h1>Bookmark 一覧</h1>
          </div>
        
          <BookmarkList :bookmarkList="bookmarkList" :itemsPerPage="itemsPerPage" @change-bookmark-list="changeBookmarkList" @put-click="togglePutModal" @delete-click="toggleDeleteModal"></BookmarkList>

          <Pagination :currentPage="currentPage" :totalPages="totalPages" @pagination="setBookmark" @change-page="changePage"></Pagination>
        </v-flex>

        <Sidebar :bookmarkList="bookmarkList" @add-click="togglePostModal"></Sidebar>
      </v-layout>

        <AddDialog :dialogPostFlag="dialogPostFlag" :categoriesForEdit="categoriesForEdit" @post-cancel-click="togglePostModal" @post-click="postBookmark"></AddDialog>

        <EditDialog :dialogPutFlag="dialogPutFlag" :categoriesForEdit="categoriesForEdit" :putTitle="putTitle" :putUrl="putUrl" :putCategory="putCategory" @edit-click="putBookmark" @edit-cancel-click="editCancel" @change-title="changeTitle" @change-url="changeUrl" @change-category="changeCategory"></EditDialog>

        <DeleteDialog :dialogDeleteFlag="dialogDeleteFlag" @delete-click="deleteBookmark" @delete-cancel-click="deleteCancel"></DeleteDialog>

    </v-container>
  </v-app> 
</template>

<script>
import Loading from './components/Loading'
import Search from './components/Search'
import BookmarkList from './components/BookmarkList'
import Pagination from './components/Pagination'
import Sidebar from './components/Sidebar'
import AddDialog from './components/AddDialog'
import EditDialog from './components/EditDialog'
import DeleteDialog from './components/DeleteDialog'
import axios from 'axios';
axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};
export default {
  data: function () {
    return {
      isLoading: true,
      bookmarkList: ['',''],
      allData: ['',''],
      categories: ['All'],
      categoriesForEdit: [],
      category: 'ALL',
      bookmarks: "bookmarks",
      dialogPostFlag: false,
      postTitle: "",
      postUrl: "",
      postCategory: "",
      dialogPutFlag: false,
      putTitle: '',
      putUrl: '',
      putCategory: '',
      dialogDeleteFlag: false,
      searchWord: '',
      currentPage: 1,
      itemsPerPage: 3,
      totalPages: null,
    }
  },
  mounted () {
    axios.get("/api/bookmarks")
    .then(response => {
        this.allData = response.data;
        this.isLoading = false;
      }
    );
    this.setBookmark();
  },
  components: {
    Loading,
    Search,
    BookmarkList,
    Pagination,
    Sidebar,
    AddDialog,
    EditDialog,
    DeleteDialog,
  },
  methods: {
    setBookmark: function () {
      const url = `/api/bookmarks?page=${this.currentPage}?per=${this.itemsPerPage}`;
      axios.get(url)
      .then(response => {
        this.allData = response.data.bookmarks
        this.bookmarkList = this.allData
        this.totalPages = response.data.total_pages
        this.listCategories();
        this.abstruct();
        }
      );
    },
    listCategories: function() {
      this.categories = []
      this.categoriesForEdit = []
      this.categories.push('ALL')
      var i = 0;
      for (i=0; i<this.allData.length; i++) {
        if (this.categories.indexOf(this.allData[i].category) == -1) {
          this.categories.push(this.allData[i].category)
          this.categoriesForEdit.push(this.allData[i].category)
        }
      }
    },
    changeBookmarkList: function(newBookmarkList) {
      this.bookmarkList = newBookmarkList
    },
    togglePostModal: function() {
      this.dialogPostFlag = !this.dialogPostFlag
    },
    postBookmark: function(...args) {
      this.postTitle = args[0]
      this.postUrl = args[1]
      this.postCategory = args[2]
      axios.post('/api/bookmarks', {title:this.postTitle, url:this.postUrl, category:this.postCategory})
        .then(response => {
          this.setBookmark();
          this.postTitle = ''
          this.postUrl = ''
          this.postCategory = ''
        }
      );
      this.dialogPostFlag = !this.dialogPostFlag
    },
    togglePutModal: function(id) {
      this.id = id
      axios.get(`/api/bookmarks/${this.id}.json`)
        .then(response => {
          this.putTitle = response.data.title
          this.putUrl = response.data.url
          this.putCategory = response.data.category
        }
      );
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
    editCancel: function() {
      this.dialogPutFlag = !this.dialogPutFlag
    },
    changeTitle: function(newTitle) {
      this.putTitle = newTitle
    },
    changeUrl: function(newUrl) {
      this.putUrl = newUrl
    },
    changeCategory: function(newCategory) {
      this.putCategory = newCategory
    },
    deleteBookmark: function() {
      axios.delete(`/api/bookmarks/${this.id}`)
        .then(response => {
          this.setBookmark();
        }
      );
      this.dialogDeleteFlag = !this.dialogDeleteFlag
    },
    toggleDeleteModal: function(id) {
      this.id = id
      this.dialogDeleteFlag = !this.dialogDeleteFlag
    },
    deleteCancel: function() {
      this.dialogDeleteFlag = !this.dialogDeleteFlag
    },
    changePage: function(newPage) {
      this.currentPage = newPage
    },
    abstruct: function() {
      var i = 0;
      if (this.category == 'ALL') {
        this.bookmarkList = []
        for (i=0; i<this.allData.length; i++) {
          if ((this.allData[i].title.indexOf(this.searchWord) !== -1) || (this.allData[i].category.indexOf(this.searchWord) !== -1)) {
            this.bookmarkList.push(this.allData[i])
          }
        }   
      } else if (this.category != '') { 
        this.bookmarkList = []
        for (i=0; i<this.allData.length; i++) {
          if (this.allData[i].category == this.category) {
            if ((this.allData[i].title.indexOf(this.searchWord) !== -1) || (this.allData[i].category.indexOf(this.searchWord) !== -1)) {
              this.bookmarkList.push(this.allData[i])
            }
          }
        }   
      }
    },
    changeSearchWord: function(newSearchWord) {
      this.searchWord = newSearchWord
    },
    changeSearchCategory: function(newSearchCategory) {
      this.category = newSearchCategory
    }
  }
}
</script>

<style scoped>
p {
  font-size: 20px;
  text-align: center;
}
a {
  text-decoration: none;
}
</style>
