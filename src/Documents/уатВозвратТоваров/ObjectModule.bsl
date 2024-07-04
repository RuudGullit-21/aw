#Область ОписаниеПеременных

Перем мВалютаРегламентированногоУчета Экспорт; // Переменная хранит значение валюты регламентированного учёта,
												// полученное из константы.

#КонецОбласти


#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// проверка на ведение складского учета средствами УАТ
	Если НЕ уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ВестиСкладскойУчетУАТ) Тогда
		ТекстНСТР = НСтр("en='For company ""%1"" the possibility of inventory management with FMS documents is disabled!';ru='Для организации ""%1"" отключена возможность ведения складского учета документами УАТ!'");
		ТекстНСТР = СтрШаблон(ТекстНСТР, Организация);
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
		Возврат;
	КонецЕсли;
	
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатВозвратТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	Документы.уатВозвратТоваров.ИнициализироватьДанныеДокумента_проф(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение.ОтразитьПартииТоваровНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	Если ПолучитьФункциональнуюОпцию("уатАдресноеХранение") = ИСТИНА И Склад.АдресноеХранение Тогда
		уатПроведение_проф.ОтразитьТоварыВЯчейках(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	уатПроведение_проф.ОтразитьДатыДвиженияТоваровНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	уатПроведение_проф.ОтразитьВзаиморасчетыСКонтрагентами(ДополнительныеСвойства, Движения, Отказ);

	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатВозвратТоваров.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	уатУчетОригиналовПервичныхДокументов.СформироватьДвиженияРеестрДокументов(Ссылка);
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = уатОбщегоНазначенияТиповые.уатПолучитьСуммуДокументаСНДС(ЭтотОбъект);
	
КонецПроцедуры // ПередЗаписью

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		уатЗащищенныеФункцииСервер_проф.ПолучитьСформироватьШтрихкодОбъекта(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.уатОприходованиеТоваров.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	уатОбщегоНазначенияТиповые.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", , Отказ, Заголовок);
	
	Если ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам тогда
		Если ЗначениеЗаполнено(ДокументОснование) И НЕ ЗначениеЗаполнено(ДокументОснование.Сделка)
			И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.уатПоступлениеТоваровУслуг") Тогда
			
			ТекстНСТР = НСтр("en='In document-based ""%1"" is not filled in invoice for payment!';ru='В документе-основании ""%1"" не заполнен счет на оплату!'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ДокументОснование);
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;

	Если УчитыватьНДС Тогда
		ПроверяемыеРеквизиты.Добавить("Товары.СтавкаНДС");
	КонецЕсли;
	
	уатОбщегоНазначения.ПроверкаЗаполненияПодразделения(Организация, Подразделение, Отказ, Заголовок);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	ДокументОснование = ДанныеЗаполнения;
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.уатПоступлениеТоваровУслуг") Тогда
		Организация = ДокументОснование.Организация;
		Контрагент = ДокументОснование.Контрагент;
		ДоговорКонтрагента = ДокументОснование.ДоговорКонтрагента;
		Склад = ДокументОснование.Склад;
		УчитыватьНДС = ДокументОснование.УчитыватьНДС; 
		СуммаВключаетНДС = ДокументОснование.СуммаВключаетНДС;
		ВалютаДокумента = ДокументОснование.ВалютаДокумента;
		КратностьВзаиморасчетов = ДокументОснование.КратностьВзаиморасчетов;
		КурсВзаиморасчетов = ДокументОснование.КурсВзаиморасчетов;
		
		Для Каждого ТекСтрока Из ДокументОснование.Товары Цикл
			НоваяСтрока						= Товары.Добавить();
			НоваяСтрока.Номенклатура		= ТекСтрока.Номенклатура;
			НоваяСтрока.ЕдиницаИзмерения	= ТекСтрока.ЕдиницаИзмерения;
			НоваяСтрока.Количество 			= ТекСтрока.Количество;
			НоваяСтрока.Цена 			    = ТекСтрока.Цена;
			НоваяСтрока.Сумма 			    = ТекСтрока.Сумма;
			НоваяСтрока.СтавкаНДС 			= ТекСтрока.СтавкаНДС;
			НоваяСтрока.СуммаНДС 			= ТекСтрока.СуммаНДС;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область Инициализация

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

#КонецОбласти