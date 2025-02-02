
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	Документы.уатПоступлениеАгрегатов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	уатПроведение.ОтразитьИзносПробегШин(ДополнительныеСвойства, Движения, Отказ);
	уатПроведение.ОтразитьОстаткиАгрегатов(ДополнительныеСвойства, Движения, Отказ);
	
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ЗаписатьРеквизитыШин(Отказ);
	ЗаписатьРеквизитыПрочихАгрегатов(Отказ);
	ЗаписатьРеквизитыАккумуляторов(Отказ);
	
	Документы.уатПоступлениеАгрегатов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.уатПоступлениеАгрегатов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	Для каждого ТекСтрокаШина Из Шины Цикл
		Если НЕ ЗначениеЗаполнено(ТекСтрокаШина.СерияНоменклатуры.Модель) Тогда 
			ТекстНСТР = НСтр("en='Not completed model of tire number %1';ru='Не заполнена модель у шины с номером %1'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ТекСтрокаШина.СерияНоменклатуры.СерийныйНомер);
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЕсли;
	КонецЦикла;
	
	// проверка на дубли строк
	Если НЕ Отказ Тогда
		тблШины = Шины.Выгрузить().Скопировать();
		тблШины.Свернуть("СерияНоменклатуры");
		Если тблШины.Количество() < Шины.Количество() Тогда
			ТекстНСТР = НСтр("en='In tabular section ""Tires"" found duplicate of products and services series!';ru='В табличной части ""Шины"" обнаружено дублирование серий номенклатуры!'");
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;
	Если НЕ Отказ Тогда
		тблАккумуляторы = Аккумуляторы.Выгрузить().Скопировать();
		тблАккумуляторы.Свернуть("СерияНоменклатуры");
		Если тблАккумуляторы.Количество() < Аккумуляторы.Количество() Тогда
			ТекстНСТР = НСтр("en='In tabular section ""Batteries"" find out duplication of products and services series!';ru='В табличной части ""Аккумуляторы"" обнаружено дублирование серий номенклатуры!'");
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;
	Если НЕ Отказ Тогда
		тблПрочиеАгрегаты = ПрочиеАгрегаты.Выгрузить().Скопировать();
		тблПрочиеАгрегаты.Свернуть("СерияНоменклатуры");
		Если тблПрочиеАгрегаты.Количество() < ПрочиеАгрегаты.Количество() Тогда
			ТекстНСТР = НСтр("en='In tabular section ""Other car parts"" detected duplicate series of products and services!';ru='В табличной части ""Прочие агрегаты"" обнаружено дублирование серий номенклатуры!'");
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;
	
	Если Не Отказ Тогда
		уатОбщегоНазначения.ПроверкаЗаполненияПодразделения(Организация, Подразделение, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.уатИнвентаризацияАгрегатов")
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументОбъект.уатИнвентаризацияАгрегатов") Тогда
		
		Организация       = ДанныеЗаполнения.Организация;
		Подразделение     = ДанныеЗаполнения.Подразделение;
		Комментарий       = ДанныеЗаполнения.Комментарий;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Ответственный     = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнойОтветственный");
		
		Если ДанныеЗаполнения.ВидОперации=Перечисления.уатВидыДокументаИнвентаризацияАгрегатов.ИнвентаризацияНаСкладах Тогда
			Склад = ДанныеЗаполнения.Склад;			
			Для Каждого ТекСтрока Из ДанныеЗаполнения.АгрегатыСклад Цикл
				// проверяем на наличие неучтенных агрегатов
				Если ТекСтрока.Наличие И НЕ ТекСтрока.НаличиеУчет Тогда
					Если ТекСтрока.Агрегат.ТипАгрегата = Справочники.уатТипыАгрегатов.Шина Тогда	
						НоваяСтрока					  = Шины.Добавить();
						НоваяСтрока.СерияНоменклатуры = ТекСтрока.Агрегат;
					ИначеЕсли ТекСтрока.Агрегат.ТипАгрегата = Справочники.уатТипыАгрегатов.Аккумулятор Тогда 
						НоваяСтрока 				  = Аккумуляторы.Добавить();
						НоваяСтрока.СерияНоменклатуры = ТекСтрока.Агрегат;
					Иначе
						НоваяСтрока 				  = ПрочиеАгрегаты.Добавить();
						НоваяСтрока.СерияНоменклатуры = ТекСтрока.Агрегат;
					КонецЕсли;					
				КонецЕсли;
			КонецЦикла;				
		Иначе			
			Для Каждого ТекСтрока Из ДанныеЗаполнения.АгрегатыТС Цикл
				// проверяем на наличие неучтенных агрегатов
				Если ТекСтрока.Наличие И НЕ ТекСтрока.НаличиеУчет Тогда
					Если ТекСтрока.Агрегат.ТипАгрегата = Справочники.уатТипыАгрегатов.Шина Тогда
						НоваяСтрока					  = Шины.Добавить();
						НоваяСтрока.СерияНоменклатуры = ТекСтрока.Агрегат;
					ИначеЕсли ТекСтрока.Агрегат.ТипАгрегата = Справочники.уатТипыАгрегатов.Аккумулятор Тогда 
						НоваяСтрока 				  = Аккумуляторы.Добавить();
						НоваяСтрока.СерияНоменклатуры = ТекСтрока.Агрегат;
					Иначе					
						НоваяСтрока 				  = ПрочиеАгрегаты.Добавить();
						НоваяСтрока.СерияНоменклатуры = ТекСтрока.Агрегат;
					КонецЕсли;				
				КонецЕсли;
			КонецЦикла;							
		КонецЕсли;		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти



#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьРеквизитыШин(Отказ)
	ТекВалюта = ?(ЗначениеЗаполнено(ВалютаДокумента), ВалютаДокумента, 
				Константы.ВалютаРегламентированногоУчета.Получить());
	Для Каждого ТекСтрокаШина Из Шины Цикл
		Если ТекСтрокаШина.СерияНоменклатуры.ПервоначальнаяСтоимость <> ТекСтрокаШина.Цена
			ИЛИ ТекСтрокаШина.СерияНоменклатуры.Валюта <> ТекВалюта Тогда
			ШинаОбъект = ТекСтрокаШина.СерияНоменклатуры.ПолучитьОбъект(); 
			ШинаОбъект.ПервоначальнаяСтоимость = ТекСтрокаШина.Цена;
			ШинаОбъект.Валюта = ТекВалюта;
			Попытка 
				ШинаОбъект.Записать();
			Исключение
				ТекстНСТР = НСтр("en='Failed to write tire ""%1""';ru='Не удалось записать шину ""%1""'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ШинаОбъект.СерийныйНомер);
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры 

Процедура ЗаписатьРеквизитыПрочихАгрегатов(Отказ)
	ТекВалюта = ?(ЗначениеЗаполнено(ВалютаДокумента), ВалютаДокумента, 
				Константы.ВалютаРегламентированногоУчета.Получить());
	Для Каждого ТекСтрока Из ПрочиеАгрегаты Цикл
		Если ТекСтрока.СерияНоменклатуры.ПервоначальнаяСтоимость <> ТекСтрока.Цена 
			ИЛИ ТекСтрока.СерияНоменклатуры.Валюта <> ТекВалюта Тогда
			СпрОб = ТекСтрока.СерияНоменклатуры.ПолучитьОбъект();
			СпрОб.ПервоначальнаяСтоимость = ТекСтрока.Цена;
			СпрОб.Валюта = ТекВалюта;
			Попытка 
				СпрОб.Записать();
			Исключение
				ТекстНСТР = НСтр("en='Failed to write car part ""%1"" (%2)';ru='Не удалось записать агрегат ""%1"" (%2)'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, СпрОб.СерийныйНомер, СпрОб.Модель);
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры 

Процедура ЗаписатьРеквизитыАккумуляторов(Отказ)
	ТекВалюта = ?(ЗначениеЗаполнено(ВалютаДокумента), ВалютаДокумента, 
	Константы.ВалютаРегламентированногоУчета.Получить());
	Для Каждого СтрАкк Из Аккумуляторы Цикл
		Если СтрАкк.СерияНоменклатуры.ПервоначальнаяСтоимость <> СтрАкк.Цена 
			ИЛИ СтрАкк.СерияНоменклатуры.Валюта <> СтрАкк.Цена  Тогда
			АккумОбъект = СтрАкк.СерияНоменклатуры.ПолучитьОбъект();
			АккумОбъект.ПервоначальнаяСтоимость = СтрАкк.Цена;
			АккумОбъект.Валюта = ТекВалюта;
			Попытка 
				АккумОбъект.Записать();
			Исключение
				ТекстНСТР = НСтр("en='Unable to write the battery ""%1"" (%2)';ru='Не удалось записать аккумулятор ""%1"" (%2)'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, АккумОбъект.СерийныйНомер, АккумОбъект.Модель);
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры 

#КонецОбласти
