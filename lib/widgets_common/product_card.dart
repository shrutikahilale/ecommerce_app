import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final String offerTag;
  final Function onTap;
  final bool hasOffer;
  final double review;
  final double numOfferPercent;

  const ProductCard(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.price,
      required this.offerTag,
      required this.onTap,
      required this.hasOffer,
      required this.review,
      required this.numOfferPercent});

  @override
  Widget build(BuildContext context) {
    double discountPrice = double.parse(
        (price - numOfferPercent * price / 100).toStringAsFixed(0));
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: 120,
              ),
              const SizedBox(height: 9),
              Text(
                name,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 9),
              IgnorePointer(
                ignoring: true,
                child: RatingBar.builder(
                    initialRating: review,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 15,
                    itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (rating) {}),
              ),
              const SizedBox(height: 9),
              Text(
                'Rs. $price',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (hasOffer)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    offerTag,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 9),
              if (numOfferPercent > 0)
                Text(
                  'Buy at Rs. $discountPrice !',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
