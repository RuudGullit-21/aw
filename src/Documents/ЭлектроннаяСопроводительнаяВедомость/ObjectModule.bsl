#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидДокумента) = Ложь Тогда
		ВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(Перечисления.ТипыДокументовЭДО.ЭСВ);
	КонецЕсли;
	
	Если РольУчастника = 0 Тогда 
		РольУчастника = 1;
	КонецЕсли;
	
	Если РольУчастника = 1 Тогда
		Организация = СсылкаТитулПеревозчикаПеревозчик;
	ИначеЕсли РольУчастника = 2 Тогда
		Организация = СсылкаТитулПеревозчикаГрузополучатель;
	ИначеЕсли РольУчастника = 3 Тогда
		Организация = СсылкаТитулПеревозчикаГрузоотправитель;
	КонецЕсли;
	
	ОбменСГИСЭПД.УстановитьТекущийШаг(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	// Запишем новую версию
	ВерсияТитула = Неопределено;
	Если ДополнительныеСвойства.Свойство("ВерсияТитула", ВерсияТитула) Тогда
		ЗаписьВерсии = РегистрыСведений.ВерсииТитуловЭПД.СоздатьМенеджерЗаписи();
		ЗаписьВерсии.Документ = Ссылка;
		ЗаписьВерсии.Организация = Организация;
		ЗаписьВерсии.Титул = ВерсияТитула.Титул;
		ЗаписьВерсии.НомерВерсии = ВерсияТитула.НомерВерсии;
		
		ЗаписьВерсии.ИдентификаторФайла = ВерсияТитула.ИдентификаторФайла;
		ЗаписьВерсии.ДатаВерсии = ВерсияТитула.ДатаВерсии;
		ЗаписьВерсии.Записать();
	КонецЕсли;
	
	// Запишем реквизиты
	Если ВерсияТитула <> Неопределено Тогда
		СтруктураРеквизитовТитула = Неопределено;
		Если ДополнительныеСвойства.Свойство("СтруктураРеквизитов", СтруктураРеквизитовТитула) Тогда
			НомерВерсии = Неопределено;
			ДополнительныеСвойства.Свойство("НомерВерсии", НомерВерсии);
			Если НомерВерсии = Неопределено Тогда
				НомерВерсии = 0;
			КонецЕсли;
			НаборЗаписейЗначений = РегистрыСведений.ЗначенияРеквизитовДокументовЭПД.СоздатьНаборЗаписей();
			НаборЗаписейЗначений.Отбор.Документ.Установить(Ссылка);
			НаборЗаписейЗначений.Отбор.Титул.Установить(ВерсияТитула.Титул);
			НаборЗаписейЗначений.Отбор.НомерВерсии.Установить(НомерВерсии);
			Для Каждого КиЗ Из СтруктураРеквизитовТитула Цикл
				МассивЧастей = ОбменСГИСЭПДКлиентСервер.РазделитьСтрокуСоСложнымРазделителем(КиЗ.Ключ, "__");
				Если МассивЧастей.Количество() = 3 Тогда
					ИмяТабличнойЧасти = МассивЧастей[0];
					НомерСтрокиРеквизита = Число(МассивЧастей[1]);
					ИмяРеквизита = МассивЧастей[2];
				Иначе
					ИмяТабличнойЧасти = "";
					НомерСтрокиРеквизита = 0;
					ИмяРеквизита = КиЗ.Ключ;
				КонецЕсли;	
				НоваяЗапись = НаборЗаписейЗначений.Добавить();
				НоваяЗапись.Документ = Ссылка;
				НоваяЗапись.Организация = Организация;
				НоваяЗапись.Титул = ВерсияТитула.Титул;
				НоваяЗапись.НомерВерсии = НомерВерсии;
				НоваяЗапись.ИмяТабличнойЧасти = ИмяТабличнойЧасти;
				НоваяЗапись.НомерСтрокиРеквизита = НомерСтрокиРеквизита;
				НоваяЗапись.ИмяРеквизита = ИмяРеквизита;
				Если КиЗ.Значение = Неопределено Или ТипЗнч(КиЗ.Значение) = Тип("Строка") Тогда 
					НоваяЗапись.ЗначениеРеквизитаСтрока = КиЗ.Значение;
					НоваяЗапись.ТипРеквизита = Перечисления.ТипыРеквизитовЭПД.НеограниченнаяСтрока;
				ИначеЕсли ТипЗнч(КиЗ.Значение) = Тип("Число")
					Или ТипЗнч(КиЗ.Значение) = Тип("Дата")
					Или ТипЗнч(КиЗ.Значение) = Тип("Булево") Тогда
						НоваяЗапись.ЗначениеРеквизита = КиЗ.Значение;
						НоваяЗапись.ТипРеквизита = Перечисления.ТипыРеквизитовЭПД.ПростойКромеСтроки;
				Иначе
					НоваяЗапись.ЗначениеРеквизитаСсылка = КиЗ.Значение;
					НоваяЗапись.ТипРеквизита = Перечисления.ТипыРеквизитовЭПД.СсылочныйТип;
				КонецЕсли;
			КонецЦикла;
			НаборЗаписейЗначений.Записать();
		КонецЕсли;
	КонецЕсли;
	
	ИдентификаторОбъектаУчета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Ссылка));
	
	СтруктураДляРеестра = ОбменСГИСЭПДКлиентСервер.НоваяСтруктураДляРеестраЭПД();
	
	СтруктураДляРеестра.Ссылка = Ссылка;	
	СтруктураДляРеестра.Грузоотправитель = СсылкаТитулПеревозчикаГрузоотправитель;
	СтруктураДляРеестра.Грузополучатель = СсылкаТитулПеревозчикаГрузополучатель;
	СтруктураДляРеестра.ДатаДокументаИБ = Дата;
	СтруктураДляРеестра.Комментарий = Комментарий;
	СтруктураДляРеестра.НомерДокументаИБ = Номер;
	СтруктураДляРеестра.НомерЭПД = ТитулПеревозчикаПорядковыйНомерСопроводительнойВедомости;
	СтруктураДляРеестра.ДатаЭПД = ТитулПеревозчикаДатаСоставленияСопроводительнойВедомости;
	СтруктураДляРеестра.Организация = Организация;
	СтруктураДляРеестра.Перевозчик = СсылкаТитулПеревозчикаПеревозчик	;
	СтруктураДляРеестра.ПометкаУдаления = ПометкаУдаления;
	СтруктураДляРеестра.Проведен = Проведен;	
	СтруктураДляРеестра.ТипСсылки = ИдентификаторОбъектаУчета;
	СтруктураДляРеестра.ТекущийШаг = ТекущийШаг;
	СтруктураДляРеестра.ТекущийШагВыполнен = ТекущийШагВыполнен;
	
	ОбменСГИСЭПД.ЗаписатьВРеестрЭПД(СтруктураДляРеестра);
	
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ОбменСГИСЭПДПереопределяемый.ОбработкаЗаполненияЭСВ(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)
	
	Если ОбъектКопирования.ЭтоВходящий = Истина Тогда
		ВызватьИсключение НСтр("ru='Нельзя копировать входящий документ'");
	КонецЕсли;
	
	ЭтотОбъект.УИДМинтранс = Неопределено;
	ЭтотОбъект.ТитулПеревозчикаПорядковыйНомерСопроводительнойВедомости = Неопределено;
	ЭтотОбъект.ТитулПеревозчикаДатаСоставленияСопроводительнойВедомости = Неопределено;
	
	ПрефиксыТитулов = ОбменСГИСЭПДКлиентСервер.ПрефиксыТитуловДокумента("Документ.ЭлектроннаяСопроводительнаяВедомость");
	Для Каждого ПрефиксТитула Из ПрефиксыТитулов Цикл
		ЭтотОбъект[ПрефиксТитула + "ИдентификаторФайла"] = Неопределено;
		ЭтотОбъект[ПрефиксТитула + "ДатаФормированияФайла"] = Неопределено;
		ЭтотОбъект[ПрефиксТитула + "ВремяФормированияФайла"] = Неопределено;
	КонецЦикла;
	ЭтотОбъект.РольУчастника = 1;
	
	Если ЭтотОбъект.ВидОперации = 0 Тогда
		ЭтотОбъект.ТекущийТитул = ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ЭСВ_Титул1_1");
	ИначеЕсли ЭтотОбъект.ВидОперации = 1 Тогда
		ЭтотОбъект.ТекущийТитул = ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ЭСВ_Титул1_2");
	ИначеЕсли ЭтотОбъект.ВидОперации = 2 Тогда
		ЭтотОбъект.ТекущийТитул = ПредопределенноеЗначение("Перечисление.ТипыЭлементовРегламентаЭДО.ЭСВ_Титул1_5");
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
