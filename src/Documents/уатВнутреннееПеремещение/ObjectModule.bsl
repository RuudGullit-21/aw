#Область ОписаниеПеременных

Перем мВалютаРегламентированногоУчета Экспорт; // Переменная хранит значение валюты регламентированного учёта,
// полученное из константы.
Перем мВалютаУпрУчета Экспорт; // Переменная хранит значение валюты управленческого учёта, полученное из константы.

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатПоступлениеТоваровУслуг")
		ИЛИ	ТипЗнч(ДанныеЗаполнения) = Тип("ДокументОбъект.уатПоступлениеТоваровУслуг")
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатОприходованиеТоваров")
		ИЛИ	ТипЗнч(ДанныеЗаполнения) = Тип("ДокументОбъект.уатОприходованиеТоваров") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		уатОбщегоНазначенияТиповые.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
		
		Дата = ТекущаяДата();
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Склад = ДанныеЗаполнения.Склад;
		
		Для Каждого ТекСтрока Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока				 	 = Товары.Добавить();
			НоваяСтрока.Номенклатура 	 = ТекСтрока.Номенклатура;
			НоваяСтрока.ЕдиницаИзмерения = ТекСтрока.ЕдиницаИзмерения;
			НоваяСтрока.Количество 	 	 = ТекСтрока.Количество;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатПеремещениеТоваров")
		ИЛИ	ТипЗнч(ДанныеЗаполнения) = Тип("ДокументОбъект.уатПеремещениеТоваров") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		уатОбщегоНазначенияТиповые.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
		
		Дата = ТекущаяДата();
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Склад = ДанныеЗаполнения.СкладПолучатель;
		
		Если Склад.АдресноеХранение Тогда
			ВидОперации = Перечисления.уатВидыОперацийВнутреннееПеремещение.ПеремещениеМеждуЯчейками;
		КонецЕсли;
				
		Для Каждого ТекСтрока Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока				 	  = Товары.Добавить();
			НоваяСтрока.Номенклатура 	  = ТекСтрока.Номенклатура;
			НоваяСтрока.ЕдиницаИзмерения  = ТекСтрока.ЕдиницаИзмерения;
			НоваяСтрока.Количество 	 	  = ТекСтрока.Количество;
			Если Склад.АдресноеХранение Тогда
				НоваяСтрока.ЯчейкаОтправитель = ТекСтрока.ЯчейкаПолучатель;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатРемонтныйЛист")
		ИЛИ	ТипЗнч(ДанныеЗаполнения) = Тип("ДокументОбъект.уатРемонтныйЛист")
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатВыдачаРасходныхМатериалов")
		ИЛИ	ТипЗнч(ДанныеЗаполнения) = Тип("ДокументОбъект.уатВыдачаРасходныхМатериалов") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		уатОбщегоНазначенияТиповые.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
		
		Дата = ДанныеЗаполнения.Дата-1;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		ВидОперации = Перечисления.уатВидыОперацийВнутреннееПеремещение.ИзвлечениеИзЯчейки;
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатРемонтныйЛист")
			ИЛИ	ТипЗнч(ДанныеЗаполнения) = Тип("ДокументОбъект.уатРемонтныйЛист") Тогда
				
			Если ДанныеЗаполнения.СпособРемонта = Перечисления.уатСпособыРемонта.Автосервис Тогда
				Склад = ДанныеЗаполнения.СкладСобственныхМатериалов;
				ТЧМатериалы = ДанныеЗаполнения.СобственныеМатериалы;
			Иначе
				Склад = ДанныеЗаполнения.Контрагент;
				ТЧМатериалы = ДанныеЗаполнения.Материалы;
			КонецЕсли;
		Иначе
			Склад = ДанныеЗаполнения.Склад;
			ТЧМатериалы = ДанныеЗаполнения.Материалы;
		КонецЕсли;
		
		Для Каждого ТекСтрока Из ТЧМатериалы Цикл
			НоваяСтрока				 	  = Товары.Добавить();
			НоваяСтрока.Номенклатура 	  = ТекСтрока.Номенклатура;
			НоваяСтрока.ЕдиницаИзмерения  = ТекСтрока.ЕдиницаИзмерения;
			НоваяСтрока.Количество 	 	  = ТекСтрока.Количество;
			НоваяСтрока.ЯчейкаПолучатель  = Склад.ТранзитнаяЯчейка;
		КонецЦикла;
				
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// проверка на ведение складского учета средствами УАТ
	Если НЕ уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ВестиСкладскойУчетУАТ) Тогда
		ТекстНСТР = СтрШаблон(НСтр("en='For company ""%1"" the possibility of inventory management with FMS documents is disabled!';ru='Для организации ""%1"" отключена возможность ведения складского учета документами УАТ!'"), Организация);
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ,, СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;
	
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатВнутреннееПеремещение.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение_проф.ОтразитьТоварыВЯчейках(ДополнительныеСвойства, Движения, Отказ);
	уатПроведение_проф.ОтразитьДатыДвиженияТоваровНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатВнутреннееПеремещение.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);

	//уатУчетОригиналовПервичныхДокументов.СформироватьДвиженияРеестрДокументов(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.уатВнутреннееПеремещение.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	уатОбщегоНазначенияТиповые.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", , Отказ, Заголовок);
	
	уатОбщегоНазначения.ПроверкаЗаполненияПодразделения(Организация, Подразделение, Отказ, Заголовок);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		уатЗащищенныеФункцииСервер_проф.ПолучитьСформироватьШтрихкодОбъекта(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область Инициализация

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
Если уатОбщегоНазначенияТиповые.уатЕстьКонстанта("ВалютаУправленческогоУчета") Тогда 
	мВалютаУпрУчета = Константы.ВалютаУправленческогоУчета.Получить();
Иначе
	мВалютаУпрУчета = мВалютаРегламентированногоУчета;
КонецЕсли;

#КонецОбласти
