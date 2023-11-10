import { db } from "../truffle-config";

db.review.insertMany([
  {
    name: "Movie A",
    price: 400,
    releaseDate: new Date("2022-10-15"),
    reviews: [
      { username: "radar", rating: 4.5 },
      { username: "movieFanatic", rating: 3.8 },
      { username: "radar", rating: 3.4 },
    ],
  },
  {
    name: "Movie B",
    price: 300,
    releaseDate: new Date("2022-09-20"),
    reviews: [
      { username: "cinemaLover", rating: 4.2 },
      { username: "filmBuff", rating: 4.0 },
      { username: "sitar", rating: 3.4 },
    ],
  },
  {
    name: "Movie C",
    price: 300,
    releaseDate: new Date("2022-11-05"),
    reviews: [{ username: "user456", rating: 3.7 }],
  },
  {
    name: "Movie D",
    price: 200,
    releaseDate: new Date("2022-11-05"),
    reviews: [{ username: "user456", rating: 3.7 }],
  },
]);

db.review.find({ $or: [{ name: "Movie D" }, { price: 200 }] });
db.review
  .find({ $and: [{ price: { $gte: 300 } }, { price: { $lte: 400 } }] })
  .pretty();
// Signal SQLstate '45000' set message_text = "fdkafkjadl"

db.review.update(
  { name: "Movie A" },
  { $set: { name: "Chicchore" } },
  { upsert: true }
);
db.review.updateMany({ price: 300 }, { $set: { price: 150 } });
db.review.find({ reviews: { $size: 3 } }).pretty();
db.review.aggregate([{ $project: { _id: 0, releaseDate: 0 } }]);
db.review.find({ hobbies: { $in: ["swimming", "reading"] } });
db.review.find({ hobbies: { $all: ["swimming", "reading"] } });
db.review.updateOne(
  { name: "Movie D" },
  { $push: { reviews: { username: "bhau", rating: 3.2 } } }
);
db.review.updateOne({ name: "Movie D" }, { $pop: { reviews: -1 } });
db.review.aggregate([{ $unwind: "$hobbies" }]);

// Assignment 2

db.review.getIndexes();
db.review.createIndex({ name: 1 });
db.review.getIndexes();
db.review.dropIndex("name_1");
db.review.createIndex({ name: 1, price: 1 });
db.review.find({ name: "Movie D" }).explain("executionStats");
db.review.createIndex({ name: 1 }, { unique: true });
db.review.createIndex(
  { price: 1 },
  { partialFilterExpression: { price: { $gt: 200 } } }
);

db.review.aggregate([{ $group: { _id: "$price" } }]);
db.review.aggregate([{ $project: { _id: 0, releaseDate: 0 } }]);
db.review.aggregate([
  { $match: { name: "Movie D" } },
  { $project: { _id: 0, name: 1 } },
]);
db.review.aggregate([
  { $group: { _id: "$price", total: { $sum: "$price" } } },
  { $project: { _id: 0, price: "$_id", total: 1 } },
  { $sort: { price: 1 } },
]);

db.review.aggregate([
  { $group: { _id: "$price", total: { $sum: "$price" } } },
  { $project: { _id: 0, price: "$_id", total: 1 } },
  { $sort: { price: 1 } },
  { $limit: 1 },
]);

db.review.aggregate([
  { $group: { _id: "$price", total: { $sum: "$price" } } },
  { $project: { _id: 0, price: "$_id", total: 1 } },
  { $sort: { price: 1 } },
  { $skip: 1 },
]);

db.student.insertMany([
  { name: "Ankita", marks: 86 },
  { name: "Ankita", marks: 92 },
  { name: "Kavita", marks: 87 },
  { name: "Kavita", marks: 74 },
  { name: "Kavita", marks: 86 },
]);

var map = function () {
  emit(this.name, this.marks);
};

var reduce = function (name, marks) {
  return Array.sum(marks);
};

db.student.mapReduce(map, reduce, { out: "Result" });

db.products.find({
  price: { $lt: 100 },
});

db.products.find({ ratings: { $avg: { $gt: 4.0 } } });
db.products.aggregate([
  {
    $project: {
      name: 1,
      category: 1,
      average: { $avg: "$ratings" },
    },
  },
  {
    $match: {
      average: { $gt: 4.0 },
    },
  },
]);
db.products.aggregate([
  {
    $project: {
      name: 1,
      price: 1,
    },
  },
]);

db.products.aggregate([
  {
    $project: {
      name: 1,
      category: 1,
      average: { $avg: "$ratings" },
    },
  },
  {
    $match: {
      category: "Fashion",
    },
  },
]);

db.products.find({
  ratings: { $gt: 4.5 },
});

db.products.find({
  "reviews.user": "user6",
});

db.products.find().sort({ price: 1 });
db.products.aggregate([
  {
    average: { $avg: "$rating" },
  },
  {
    $sort: { average: -1 },
  },
]);

db.products.aggregate([
  {
    $group: {
      _id: null,
      average: { $avg: "$ratings" },
    },
  },
  {
    $sort: { average: -1 },
  },
]);

db.products.aggregate([
  {
    $project : {
      _id : 0,
      name : 1,
      average : {$avg : "$ratings"}
    },
    $match : {
      $max : {average}
    }
  },
])

db.products.aggregate([
  {
    $group : {
      _id : "$category",
      total : {$sum : 1}
    }
  }
])

db.products.aggregate([
  {
    $unwind : "$ratings"
  },
  {
    $group : {
      _id : "$category",
      average : {$avg : "$ratings"}
    }
  },
  {
    $sort : {
      average : -1
    }
  },
  {
    $limit : 1
  },
  {
    $project : {
      _id : 0,
      category : "$_id",
      average : 1
    }
  }
])

db.products.update({category : "Electronics"},{
  $set : {price : {$incr : 0.1 * price}}
})

db.products.update({_id : 1},{
  review : {$push : {user : "dummy", comment : "Goodfdakfj"}}
})

db.products.update([
  {_id : 2}, {
    $push : {review : {user : "dummy", comment : "fdaoifjadf"}}
  }
])

db.products.delete({_id : 5})

db.reduce.insertMany([
  { "product": "A", "quantity": 10, "price": 20 },
  { "product": "B", "quantity": 5, "price": 15 },
  { "product": "A", "quantity": 8, "price": 25 },
  { "product": "C", "quantity": 12, "price": 18 },
  { "product": "B", "quantity": 6, "price": 22 }
]
);


var mapFunc = function() {
  emit(this.product, this.price);
};

var reduceFunc = function(key, value) {
  return Array.sum(value);
}

db.redece.mapReduce(mapFunc,reduceFunc,{out : "simpleOut"});


db.orders.insertMany([
  { "customerId": 1, "product": "A", "quantity": 2, "price": 30 },
  { "customerId": 1, "product": "B", "quantity": 3, "price": 25 },
  { "customerId": 2, "product": "C", "quantity": 1, "price": 40 },
  { "customerId": 2, "product": "A", "quantity": 5, "price": 35 },
  { "customerId": 1, "product": "B", "quantity": 2, "price": 28 },
  { "customerId": 3, "product": "C", "quantity": 4, "price": 45 },
  { "customerId": 3, "product": "A", "quantity": 3, "price": 33 }
]
)

var mapFunc = function() {
  emit(this.customerId, {totalAmount : this.price * this.quantity, orderCount : 1});
}

var reduceFunc = function(key, values) {
  var reducedValue = {totalAmount : 0, orderCount : 0};
  values.forEach(function(value){
    reducedValue.totalAmount+=value.totalAmount;
    reducedValue.orderCount+=value.orderCount;
  })
  return reducedValue;
}

db.orders.mapReduce(mapFunc, reduceFunc, {out : "complexMap"});


db.projects.aggregate([
  {
    $match : {department : "IT", salary : {$gt : 60000}}
  },
  {
    $group : {_id : null, average : {$avg : "$salary"}}
  }
])

db.project.aggregate([
  {
    $sort : {salary : -1}
  },
  {
    $limit : 1
  }
])

db.project.find({
  $and : [{"projects.name" : "Project A"}, {"projects.status" : "ongoing"}]
})

db.project.update(
  {
    name : "Charlie"
  },
  {
    $push : {projects : {name : "Project F", status : "planned"}}
  }
)

db.project.aggregate([
  {
    $group : {
      _id : "$department",
      total_count : {$sum : 1}
    },
  },
    {
      $project : {
        _id : 1,
        total_count : 1
      }
    }
  
])

db.project.update(
  {
    "projects.status": "completed"
  },
  {
    $pull: {
      projects: {
        status: "completed"
      }
    }
  },
)

db.project.find({$text : {$search : "a"}}, {name : 1})
db.project.find({name : {
  $regex : "a",
  $options : "i"
}})