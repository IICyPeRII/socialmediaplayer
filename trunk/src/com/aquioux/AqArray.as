/*
--------------------------------------------------
AqArray
�@�g�� Array
--------------------------------------------------
*/


package com.aquioux{
// �p�b�P�[�W�������ƃG���[�ɂȂ�
// Array�i�g�b�v���x���j��R�[�����Ă��邽�߂炵��

	import com.aquioux.AqMath;


	public dynamic class AqArray extends Array {

		// -------------------- �v���p�e�B --------------------
		// �Ȃ�

		// -------------------- ���\�b�h --------------------
		// �R���X�g���N�^
		public function AqArray() {

			if ( ( arguments.length == 1 ) && ( !isNaN( arguments[0] ) ) ) {
				// ��Ƃ��Đ��l���ЂƂ����w�肳�ꂽ�ꍇ�i��Ƃ��Ĕz��̒�����w��j
				this.length = arguments[0];
			} else {
				this.push.apply( this , arguments );
			}
		}


		// �z��̗v�f��V���b�t������
		public function shuffle():void {

			var l:int = length;
			while( l-- ) {
				var n:Number = AqMath.createRandomInt( l );
//				var n:Number = Math.floor( Math.random() * ( l + 1 ) );
				var f = this[ n ];		// Array �v�f�Ƃ��ĉ����i�[����Ă��邩������Ȃ��̂ŁAf �͌^�w��ⵂȂ�
				splice( n , 1 );
				push( f );
			}
		}

/*
		// �e�v�f�𐔒l�Ƃ��č��v����i join �̌v�Z�Łj
		public function joinNum():Number {

			var n:Number = 0;
			for ( var i:int=0; i<this.length; i++ ) { n += this[i]; }

			return n;
		}
*/

		// ������ len �̔z���쐬
		// �z��̗v�f�� start ����J�n�A������ rate
		// start�Arate �͂��ꂼ���2�A��3��Ŏw��A�ȗ���
		// �ȗ������ꍇ�́Astart = 0 , rate = 1
		public function createSequenceNumArray( len:uint , start:Number=0 , rate:Number=1 ):void {
			// len   : �z��
			// start : �J�n��
			// rate  : ���W�

			for ( var i:int=0; i<len; i++ ) { this[i] = ( i * rate ) + start; }
		}

		// ������ len �̔z���쐬
		// �z��̗v�f�� start ����J�n�A������ rate
		// start�Arate �͂��ꂼ���4�A��3��Ŏw��A�ȗ���
		// �ȗ������ꍇ�́Astart = 0 , rate = 1
		// �z��̕я��� idx �Ŏw�肷��
		// 1�F�����A2�F�t���A3�F�V���b�t���A4�F�����A0�F1�`3�܂ł̂����ꂩ�㉃��_����
		public function createNumArray( len:uint , idx:int=1 , start:Number=0 , rate:Number=1 ):void {
			// len   : �z��
			// idx   : �z��̕я�
			// start : �J�n��
			// rate  : ���W�

			// ��2��̏���
			if ( idx == 0 ) { idx = AqMath.createRandomInt( 3 , 1 ); }
//			if ( idx == 0 ) { idx = Math.floor( Math.random() * ( 3 + 1 ) ) + 1; }

			// ��z��̍쐬
			this.createSequenceNumArray( len , start , rate );

			// �쐬�����z��̕я��̒���
			switch( idx ) {
				case 1:					// ����
					break;
				case 2:					// �t��
					this.reverse();
					break;
				case 3:					// �V���b�t��
					this.shuffle();
					break;
				case 4:					// ����
					for ( var i=0; i<len; i++ ) { this[ i ] = start; }
					break;
				default:				// �� idx ���Ԉ�BĂ����ꍇ�� 1:�����Ƃ��Ĉ���
					break;
			}
		}
	}
}
