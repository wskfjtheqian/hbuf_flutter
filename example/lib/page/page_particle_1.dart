import 'package:flutter/material.dart';
import 'package:hbuf_flutter/widget/particle_animation.dart';

class PageParticle1 extends StatefulWidget {
  const PageParticle1({Key? key}) : super(key: key);

  @override
  _PageParticle1State createState() => _PageParticle1State();
}

class _PageParticle1State extends State<PageParticle1> {
  var _controller = ParticleAnimationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Particle1"),),
      body: GestureDetector(
        onPanUpdate: (details) {
          _controller.addPosition(details.localPosition);
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: ParticleAnimation(
            controller: _controller,
            providers: const [AssetImage("assets/icons/icon_money.webp")],
          ),
        ),
      ),
    );
  }
}
