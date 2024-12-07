import Rails from "@rails/ujs";
Rails.start();

// 将 Rails 挂载到全局对象
window.Rails = Rails;
console.log("Rails UJS started");

import "@hotwired/turbo-rails"
import "controllers"
import "./cart"; // 引入 cart.js


